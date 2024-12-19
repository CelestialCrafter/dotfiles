use std::fmt::Display;

use notify_rust::Notification;

pub fn error(context: &str, err: impl Display) {
    eprintln!("{}: {}", context, err);


    let result =  Notification::new()
        .summary("akari-connect error")
        .body(format!("{}:\n{}", context, err).as_str())
        .show();

    if let Err(err) = result {
        eprintln!("could not send notification: {}", err);
    };
}
