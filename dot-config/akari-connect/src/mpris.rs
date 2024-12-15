use std::{sync::{mpsc::Receiver, RwLock}, time::Duration};

use eyre::Result;
use mpris::{DBusError, Metadata, PlaybackStatus, Player, PlayerFinder};

use crate::dbus::{definition::OrgAwesomewmAkariconnect, Bus};

static ACTIVE_INDEX: RwLock<usize> = RwLock::new(0);

pub enum Action {
    PlayPause,
    Next,
    Previous,
    Seek(u64),
    Shift(isize)
}

pub struct Manager {
    player_count: usize,
    finder: PlayerFinder
}

impl Manager {
    pub fn new() -> Result<Self> {
        Ok(Self {
            player_count: usize::default(),
            finder: PlayerFinder::new()?
        })
    }

    pub fn send(&mut self, bus: &Bus) -> Result<()> {
        let position_success = match self.position() {
            Some(Ok(p)) => {
                if let Err(err) = bus.proxy.position(p.as_micros() as u64) {
                    eprintln!("could not send position to bus: {}", err);
                }
                true
            },
            Some(Err(err)) => {
                eprintln!("could not get position: {}", err);
                false
            },
            _ => false
        };

        let status_success = match self.status() {
            Some(Ok(s)) => {
                if let Err(err) = bus.proxy.status(match s {
                    PlaybackStatus::Playing => "playing",
                    _ => "paused",
                }) {
                    eprintln!("could not send status to bus: {}", err);
                }
                true
            },
            Some(Err(err)) => {
                eprintln!("could not get status: {}", err);
                false
            },
            _ => false
        };

        let metadata_success = match self.metadata() {
            Some(Ok(m)) => {
                let art = m.art_url().unwrap_or_default();
                let album = m.album_name().unwrap_or_default();
                let artist = m.artists().unwrap_or_default().join(", ");
                let title = m.title().unwrap_or_default();
                let length = m.length().unwrap_or_default();

                if let Err(err) = bus.proxy.metadata(
                    title,
                    album,
                    artist.as_str(),
                    length.as_micros() as u64,
                    art
                ) {
                    eprintln!("could not send metadata to bus: {}", err);
                };

                true
            },
            Some(Err(err)) => {
                eprintln!("could not get metadata: {}", err);
                false
            },
            _ => false
        };

        if !(position_success || status_success || metadata_success) {
            if let Err(err) = bus.proxy.empty() {
                eprintln!("could not send empty to bus: {}", err);
            };
        }

        Ok(())
    }

    pub fn receive(mut self, rx: Receiver<Action>) -> Result<()> {
        while let Ok(action) = rx.recv() {
            let player = if let Some(p) = self.active() { p } else {
                continue;
            };

            let result = match action {
                Action::PlayPause => player.play_pause(),
                Action::Next => player.next(),
                Action::Previous => player.previous(),
                Action::Seek(time) => {
                    (|| {
                        let metadata = player.get_metadata()?;
                        let track_id = metadata.track_id().ok_or(DBusError::Miscellaneous("no track id".to_string()))?;
                        player.set_position(track_id, &Duration::from_micros(time))
                    })()
                }
                Action::Shift(by) => Ok(self.shift(by))
            };

            if let Err(err) = result {
                eprintln!("mpris action error: {}", err);
            }
        }

        Ok(())
    }

    pub fn position(&mut self) -> Option<Result<Duration, DBusError>> {
        self.active().map(|p| p.get_position())
    }

    pub fn metadata(&mut self) -> Option<Result<Metadata, DBusError>> {
        self.active().map(|p| p.get_metadata())
    }

    pub fn status(&mut self) -> Option<Result<PlaybackStatus, DBusError>> {
        self.active().map(|p| p.get_playback_status())
    }

    fn active(&mut self) -> Option<Player> {
        let mut players = self.finder.find_all().ok()?;

        self.player_count = players.len();
        let active_index = ACTIVE_INDEX.read().unwrap();
        let mut new_active = *active_index;

        let map = players
            .iter()
            .enumerate()
            .position(|(i, p)| {
                if p.is_running() && !players[new_active].is_running() {
                    new_active = i;
                }

                i == new_active 
            })
        .map(|i| players.remove(i));

        if *active_index != new_active {
            drop(active_index);
            *ACTIVE_INDEX.write().unwrap() = new_active;
        }

        map
    }

    fn shift(&mut self, by: isize) {
        if self.player_count == 0 {
            return
        }

        let mut active_index = ACTIVE_INDEX.write().unwrap();

        if by.is_negative() {
            if let None = active_index.checked_sub(1) {
                *active_index = self.player_count - 1;
                return
            }

            *active_index -= 1;
        } else {
            if *active_index + 1 >= self.player_count {
                *active_index = 0;
                return
            }

            *active_index += 1;
        }
    }
}
