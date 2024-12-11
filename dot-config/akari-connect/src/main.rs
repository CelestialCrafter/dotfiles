use std::{sync::mpsc, thread, time::Duration};

use config::USER_CONFIG;
use mpris::Manager;
use dbus::AWMBus;
use crate::dbus::definition::OrgAwesomewmAkariconnect;
use ::mpris::PlaybackStatus;

pub mod config;
pub mod dbus;
pub mod mpris;

fn main() {
    let (manager_tx, manager_rx) = mpsc::channel();

    let t1 = thread::spawn(|| {
        let bus = AWMBus::new().expect("could not start dbus");
        let mut manager = Manager::new().expect("could not start manager");

        for i in 0.. {
            thread::sleep(Duration::from_secs_f32(USER_CONFIG.base_media_update_interval));

            match manager.position() {
                Ok(p) => if let Err(err) = bus.proxy.position(p.as_micros() as u64) {
                    eprintln!("could not send position to bus: {}", err);
                },
                Err(err) => eprintln!("could not get position: {}", err)
            };

            match manager.status() {
                Ok(s) => if let Err(err) = bus.proxy.status(match s {
                    PlaybackStatus::Playing => "playing",
                    _ => "paused",
                }) {
                    eprintln!("could not send status to bus: {}", err);
                },
                Err(err) => eprintln!("could not get status: {}", err)
            }

            if i % 2 == 0 {
                continue;
            }

            match manager.metadata() {
                Ok(m) => {
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
                },
                Err(err) => eprintln!("could not get metadata: {}", err)
            };
        }
    });

    let t2 = thread::spawn(|| {
        AWMBus::listen(manager_tx).expect("could not listen for signals");
    });

    let t3 = thread::spawn(|| {
        Manager::start(manager_rx).expect("could not start manager");
    });

    t1.join().unwrap();
    t2.join().unwrap();
    t3.join().unwrap();
}
