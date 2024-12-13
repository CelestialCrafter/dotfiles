use std::{thread, time::Duration, sync::mpsc};

use config::USER_CONFIG;
use dbus::Bus;

pub mod config;
pub mod dbus;
pub mod networkmanager;
pub mod mpris;

fn main() {
    let mut threads = vec![];

    // event loop
    threads.push(thread::spawn(|| {
        let bus = Bus::new().expect("could not start bus");
        let duration = Duration::from_secs_f32(USER_CONFIG.connect_update_interval);

        let mut mpris = mpris::Manager::new().expect("could not create manager");
        let nm = networkmanager::Manager::new();

        loop {
            thread::sleep(duration);

            if let Err(err) = mpris.send(&bus) {
                eprintln!("mpris send error: {}", err);
            }

            if let Err(err) = nm.send(&bus) {
                eprintln!("networkmanager send error: {}", err);
            }
        }
    }));

    // receivers
    let (mpris_tx, mpris_rx) = mpsc::channel();
    let (nm_tx, nm_rx) = mpsc::channel();

    threads.push(thread::spawn(|| {
        mpris::Manager::new()
            .expect("could not create mpris")
            .receive(mpris_rx)
            .expect("could not start mpris");
        }));

    threads.push(thread::spawn(|| {
        networkmanager::Manager::new()
            .receive(nm_rx)
            .expect("could not start nm receiver");
    }));

    threads.push(thread::spawn(|| {
        Bus::new()
            .expect("could not start bus")
            .receive(mpris_tx, nm_tx)
            .expect("could not listen for signals");
        }));

    for thread in threads {
        thread.join().unwrap();
    }
}
