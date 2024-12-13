use std::{thread, time::Duration, sync::mpsc};

use config::USER_CONFIG;
use mpris::Manager;
use dbus::AWMBus;

pub mod config;
pub mod dbus;
pub mod mpris;

fn main() {
    let (manager_tx, manager_rx) = mpsc::channel();

    let t1 = thread::spawn(|| {
        let bus = AWMBus::new().expect("could not start dbus");
        Manager::new()
            .expect("could not create manager")
            .send(bus, Duration::from_secs_f32(USER_CONFIG.base_media_update_interval))
            .expect("could not start manager");
    });

    let t2 = thread::spawn(|| {
        AWMBus::send(manager_tx).expect("could not listen for signals");
    });

    let t3 = thread::spawn(|| {
        Manager::new()
            .expect("could not create manager")
            .receive(manager_rx)
            .expect("could not start manager");
    });

    t1.join().unwrap();
    t2.join().unwrap();
    t3.join().unwrap();
}
