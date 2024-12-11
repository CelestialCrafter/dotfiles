use std::{sync::{mpsc::Receiver, RwLock}, time::Duration};

use eyre::{OptionExt, Result};
use mpris::{DBusError, PlaybackStatus, Player, PlayerFinder};

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

    pub fn start(rx: Receiver<Action>) -> Result<Self> {
        let mut manager = Self::new()?;

        while let Ok(action) = rx.recv() {
            let player = if let Some(p) = manager.active() { p } else {
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
                Action::Shift(by) => Ok(manager.shift(by))
            };

            if let Err(err) = result {
                eprintln!("mpris action error: {}", err);
            }
        }

        Ok(manager)
    }

    pub fn position(&mut self) -> Result<Duration> {
        Ok(self.active().ok_or_eyre("no active player")?.get_position()?)
    }

    pub fn metadata(&mut self) -> Result<::mpris::Metadata> {
        Ok(self.active().ok_or_eyre("no active player")?.get_metadata()?)
    }

    pub fn status(&mut self) -> Result<PlaybackStatus> {
        Ok(self.active().ok_or_eyre("no active player")?.get_playback_status()?)
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
