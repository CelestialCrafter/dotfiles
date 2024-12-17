use std::fmt::Display;

use notify_rust::Notification;

pub fn error(context: &str, err: impl Display) {
    eprintln!("{}: {}", context, err);

    Notification::new()
        .summary("akari-connect error")
        .body(format!("{}:\n{}", context, err).as_str())
        .show()
        .unwrap();
}
