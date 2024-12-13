use std::sync::mpsc::Receiver;

use eyre::{eyre, OptionExt, Result};
use network_manager::{Connection, NetworkManager};

use crate::dbus::{definition::OrgAwesomewmAkariconnect, Bus};

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

    fn get_network(&self, ssid: String) -> Result<Connection> {
        let connections = self.nm.get_connections().map_err(|_| eyre!("could not get connections"))?;
        let selected = connections.into_iter().find(|c| c.settings().ssid.as_str().expect("could not get ssid") == ssid);
        Ok(selected.ok_or_eyre("could not find network")?)
    }

    pub fn receive(&self, rx: Receiver<Action>) -> Result<()> {
        while let Ok(action) = rx.recv() {
            match action {
                Action::Connect(ssid) => {
                    self.get_network(ssid)?
                        .activate()
                        .map_err(|_| eyre!("could not activate network"))?
                },
                Action::Disconnect(ssid) => {
                    self.get_network(ssid)?
                        .deactivate()
                        .map_err(|_| eyre!("could not activate network"))?
                },
            };
        }

        Ok(())
    }

    pub fn send(&self, bus: &Bus) -> Result<()> {
        let connections = self.nm.get_connections().map_err(|_| eyre!("could not get connections"))?;
        let networks: Vec<(i16, &str, &str)> = connections
            .iter()
            .map(|c| {
                let settings = c.settings();
                let state = c.get_state().map_err(|_| eyre!("could not get state"))?;
                let values = (
                    state as i16,
                    settings.ssid.as_str().map_err(|_| eyre!("could not get ssid"))?,
                    settings.uuid.as_str()
                );

                Ok::<_, eyre::ErrReport>(values)
            })
        .filter_map(|d| d.ok())
        .collect();

        bus.proxy.networks(networks)?;

        Ok(())
    }
}
