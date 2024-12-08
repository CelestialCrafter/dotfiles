use std::time::Duration;

use dbus::blocking::{Connection, Proxy};
use eyre::Result;

const AWM_DEST: &str = "org.awesomewm.akariconnect";
const TIMEOUT: Duration = Duration::from_millis(5000);

pub struct AWMBus<'a> {
    proxy: Proxy<'a, Connection>
}

impl AWMBus<'_> {
    pub fn new() -> Result<Self> {
        let conn = Connection::new_session()?;
        let proxy = Proxy::new(AWM_DEST, "/", TIMEOUT, conn);

        Ok(Self { proxy })
    }
}

