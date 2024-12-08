use std::time::Duration;

use dbus::blocking::Connection;
use eyre::Result;

fn main() -> Result<()> {
    let conn = Connection::new_session()?;
    let proxy = conn.with_proxy("org.freedesktop.DBus", "/", Duration::from_millis(5000));

    let (names,): (Vec<String>,) = proxy.method_call("org.freedesktop.DBus", "ListNames", ())?;

    for name in names {
        println!("{}", name);
    }

    Ok(())
}
