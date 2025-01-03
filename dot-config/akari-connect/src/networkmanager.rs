use std::sync::mpsc::Receiver;

use eyre::{eyre, OptionExt, Result};
use network_manager::{Connection, ConnectionState, NetworkManager};

use crate::{dbus::{definition::OrgAwesomewmAkariconnect, Bus}, log};

pub struct Manager {
    nm: NetworkManager
}

pub enum Action {
    Connect(String),
    Disconnect(String)
}

impl Manager {
    pub fn new() -> Self {
        Self { nm: NetworkManager::new() }
    }

    fn get_network(&self, uuid: String) -> Result<Connection> {
        let connections = self.nm.get_connections()
            .map_err(|_| eyre!("could not get connections"))?;
        let selected = connections
            .into_iter()
            .find(|c| c.settings().uuid == uuid);
        Ok(selected.ok_or_eyre("could not find network")?)
    }

    pub fn receive(&self, rx: Receiver<Action>) {
        while let Ok(action) = rx.recv() {
            let result = (|| {
                match action {
                    Action::Connect(uuid) => {
                        self.get_network(uuid)?
                            .activate()
                            .map_err(|_| eyre!("could not activate network"))?
                    },
                    Action::Disconnect(uuid) => {
                        self.get_network(uuid)?
                            .deactivate()
                            .map_err(|_| eyre!("could not deactivate network"))?
                    },
                };

                Ok::<_, eyre::ErrReport>(())
            })();

            if let Err(err) = result {
                log::error("could not run nm action", err);
            }
        }
    }

    pub fn send(&self, bus: &Bus) -> Result<()> {
        let formatted: Vec<(i16, String, String)> = self.nm.get_connections()
            .map_err(|_| eyre!("could not get connections"))?
            .into_iter()
            .filter(|c| c.settings().kind != "loopback")
            .filter_map(|c| {
                let settings = c.settings();
                let state = c.get_state().unwrap_or(ConnectionState::Unknown);

                Some((
                    state as i16,
                    settings.id.clone(),
                    settings.uuid.clone()
                ))
            })
            .collect();

        let refs = formatted
            .iter()
            .map(|(state, ssid, uuid)| (*state, ssid.as_str(), uuid.as_str()))
            .collect();

        bus.proxy.networks(refs)?;

        Ok(())
    }
}
