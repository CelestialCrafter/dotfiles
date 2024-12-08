use std::time::Duration;

use dbus::blocking::Connection;
use eyre::Result;

const AWM_DEST: &str = "org.awesomewm.awful";

fn main() -> Result<()> {
    let conn = Connection::new_session()?;
    let proxy = conn.with_proxy(AWM_DEST, "/", Duration::from_millis(5000));

    let (result,): (f64,) = proxy.method_call(format!("{}.Remote", AWM_DEST), "Eval", ("return 1+1",))?;
    println!("{}", result);

    Ok(())
}
