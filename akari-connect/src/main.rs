use std::time::Duration;

use dbus::blocking::Connection;
use eyre::Result;

const AWM_DEST: &str = "org.awesomewm.akariconnect";

fn main() -> Result<()> {
    let conn = Connection::new_session()?;
    let proxy = conn.with_proxy(AWM_DEST, "/", Duration::from_millis(5000));

    proxy.method_call(AWM_DEST, "Test", ())?;

    Ok(())
}
