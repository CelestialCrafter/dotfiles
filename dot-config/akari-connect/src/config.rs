use std::{fs, sync::LazyLock};

use mlua::{Lua, LuaSerdeExt};
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct User {
    pub connect_update_interval: f32,
}

pub static USER_CONFIG: LazyLock<User> = LazyLock::new(|| {
    let user_config_path = dirs_next::config_dir()
        .expect("config dir should exist")
        .join("awesome/user.lua");

    let lua = Lua::new();
    let user = lua
        .load(fs::read_to_string(user_config_path).expect("could not read user.lua"))
        .eval()
        .expect("could not evaluate user.lua");

    let user: User = lua.from_value(user).expect("could not convert user config");

    user
});
