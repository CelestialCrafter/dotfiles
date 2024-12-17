pub mod definition;

use std::{rc::Rc, sync::mpsc::Sender, time::Duration};

use dbus::{blocking::{Connection, Proxy}, Message};
use eyre::Result;

use crate::{log, mpris, networkmanager};

const BUS_NAME: &str = "org.awesomewm.akariconnect";
const TIMEOUT: Duration = Duration::from_millis(5000);

pub struct Bus<'a> {
    pub proxy: Proxy<'a, Rc<Connection>>,
}

impl Bus<'_> {
    pub fn new() -> Result<Self> {
        let connection = Rc::new(Connection::new_session()?);
        let proxy = Proxy::new(BUS_NAME, "/", TIMEOUT, connection);
        Ok(Self { proxy })
    }

    pub fn receive(self, mpris: Sender<mpris::Action>, nm: Sender<networkmanager::Action>) {
        // ew
        {
            let tx = mpris.clone();
            let _ = self.proxy.match_signal(move |_: definition::OrgAwesomewmAkariconnectPlayPause, _: &Connection, _: &Message| {
                eprintln!("received signal: play/pause");
                tx.send(mpris::Action::PlayPause).unwrap();
                true
            });
        }

        {
            let tx = mpris.clone();
            let _ = self.proxy.match_signal(move |_: definition::OrgAwesomewmAkariconnectNext, _: &Connection, _: &Message| {
                eprintln!("received signal: next");
                tx.send(mpris::Action::Next).unwrap();
                true
            });
        }

        {
            let tx = mpris.clone();
            let _ = self.proxy.match_signal(move |_: definition::OrgAwesomewmAkariconnectPrevious, _: &Connection, _: &Message| {
                eprintln!("received signal: previous");
                tx.send(mpris::Action::Previous).unwrap();
                true
            });
        }

        {
            let tx = mpris.clone();
            let _ = self.proxy.match_signal(move |h: definition::OrgAwesomewmAkariconnectSeek, _: &Connection, _: &Message| {
                eprintln!("received signal: seek");
                tx.send(mpris::Action::Seek(h.time)).unwrap();
                true
            });
        }

        {
            let tx = mpris.clone();
            let _ = self.proxy.match_signal(move |h: definition::OrgAwesomewmAkariconnectShift, _: &Connection, _: &Message| {
                eprintln!("received signal: shift");
                tx.send(mpris::Action::Shift(h.by.into())).unwrap();
                true
            });
        }

        {
            let tx = nm.clone();
            let _ = self.proxy.match_signal(move |h: definition::OrgAwesomewmAkariconnectConnect, _: &Connection, _: &Message| {
                eprintln!("received signal: connect");
                tx.send(networkmanager::Action::Connect(h.ssid)).unwrap();
                true
            });
        }

        {
            let tx = nm.clone();
            let _ = self.proxy.match_signal(move |h: definition::OrgAwesomewmAkariconnectDisconnect, _: &Connection, _: &Message| {
                eprintln!("received signal: disconnect");
                tx.send(networkmanager::Action::Disconnect(h.ssid)).unwrap();
                true
            });
        }

        loop {
            let result = self.proxy.connection.process(Duration::from_millis(1000));
            if let Err(err) = result {
                log::error("bus process error", err);
            }
        }
    }
}

