pub mod definition;

use std::{rc::Rc, sync::mpsc::Sender, time::Duration};

use dbus::{blocking::{Connection, Proxy}, Message};
use definition::{OrgAwesomewmAkariconnectNext, OrgAwesomewmAkariconnectPlayPause, OrgAwesomewmAkariconnectPrevious, OrgAwesomewmAkariconnectSeek, OrgAwesomewmAkariconnectShift};
use eyre::Result;

use crate::mpris::Action;

const BUS_NAME: &str = "org.awesomewm.akariconnect";
const TIMEOUT: Duration = Duration::from_millis(5000);

pub struct AWMBus<'a> {
    pub proxy: Proxy<'a, Rc<Connection>>
}

impl AWMBus<'_> {
    pub fn new() -> Result<Self> {
        let conn = Rc::new(Connection::new_session()?);
        let proxy = Proxy::new(BUS_NAME, "/", TIMEOUT, conn);
        Ok(Self { proxy })
    }

    pub fn listen(manager: Sender<Action>) -> Result<()> {
        let conn = Rc::new(Connection::new_session()?);
        let proxy = Proxy::new(BUS_NAME, "/", TIMEOUT, conn);

        // ew
        {
            let m = manager.clone();
            let _ = proxy.match_signal(move |_: OrgAwesomewmAkariconnectPlayPause, _: &Connection, _: &Message| {
                eprintln!("received signal: play/pause");
                m.send(Action::PlayPause).unwrap();
                true
            });
        }

        {
            let m = manager.clone();
            let _ = proxy.match_signal(move |_: OrgAwesomewmAkariconnectNext, _: &Connection, _: &Message| {
                eprintln!("received signal: next");
                m.send(Action::Next).unwrap();
                true
            });
        }

        {
            let m = manager.clone();
            let _ = proxy.match_signal(move |_: OrgAwesomewmAkariconnectPrevious, _: &Connection, _: &Message| {
                eprintln!("received signal: previous");
                m.send(Action::Previous).unwrap();
                true
            });
        }

        {
            let m = manager.clone();
            let _ = proxy.match_signal(move |h: OrgAwesomewmAkariconnectSeek, _: &Connection, _: &Message| {
                eprintln!("received signal: seek");
                m.send(Action::Seek(h.time)).unwrap();
                true
            });
        }

        {
            let m = manager.clone();
            let _ = proxy.match_signal(move |h: OrgAwesomewmAkariconnectShift, _: &Connection, _: &Message| {
                eprintln!("received signal: shift");
                m.send(Action::Shift(h.by.into())).unwrap();
                true
            });
        }

        loop {
            proxy.connection.process(Duration::from_millis(1000))?;
        }
    }
}

