use std::{thread, time::Duration, sync::mpsc};

use config::USER_CONFIG;
use dbus::Bus;

pub mod config;
pub mod dbus;
pub mod networkmanager;
pub mod mpris;
pub mod log;

fn main() {
    let mut threads = vec![];

    // event loop
    threads.push(thread::spawn(|| {
        let bus = Bus::new().expect("could not start bus");
        let duration = Duration::from_secs_f32(USER_CONFIG.connect_update_interval);

        let mut mpris = mpris::Manager::new();
        let nm = networkmanager::Manager::new();

        if let Err(ref err) = mpris {
            log::error("could not create mpris manager", err);
        }

        loop {
            thread::sleep(duration);

            if let Ok(ref mut mpris) = mpris {
                if let Err(err) = mpris.send(&bus) {
                    log::error("mpris send error", err);
                }
            }

            if let Err(err) = nm.send(&bus) {
                log::error("networkmanager send error", err);
            }
        }
    }));

    // receivers
    let (mpris_tx, mpris_rx) = mpsc::channel();
    let (nm_tx, nm_rx) = mpsc::channel();

    threads.push(thread::spawn(move || {
        match mpris::Manager::new() {
            Err(err) => log::error("could not create mpris manager", err),
            Ok(mut mpris) => mpris.receive(mpris_rx)
        }
    }));

    threads.push(thread::spawn(move || {
        networkmanager::Manager::new().receive(nm_rx)
    }));

    threads.push(thread::spawn(|| {
        Bus::new()
            .expect("could not start bus")
            .receive(mpris_tx, nm_tx)
    }));

    for thread in threads {
        thread.join().unwrap();
    }
}
