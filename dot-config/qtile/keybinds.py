from libqtile import qtile
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.config import Key, Click, Drag
from groups import groups

mod = "mod4"
terminal = guess_terminal()

keys = [
    # focus
    Key([mod], "h", lazy.layout.left(), desc="focus left"),
    Key([mod], "l", lazy.layout.right(), desc="focus right"),
    Key([mod], "j", lazy.layout.down(), desc="focus down"),
    Key([mod], "k", lazy.layout.up(), desc="focus up"),
    Key([mod], "tab", lazy.layout.next(), desc="focus next"),
    Key([mod, "shift"], "tab", lazy.layout.previous(), desc="focus previous"),

    # move
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="move left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="move right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="move down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="move up"),

    # resize
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shrink_main().when(layout="spiral"),
        lazy.layout.decrease_ratio().when(layout="tile"),
        desc="shrink main"
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_main().when(layout="spiral"),
        lazy.layout.increase_ratio().when(layout="tile"),
        desc="grow main"
    ),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.increase_ratio().when(layout="spiral"),
        lazy.layout.decrease_nmaster().when(layout="tile"),
        desc="grow ratio"
    ),
    Key(
        [mod, "control"],
        "k",
        lazy.layout.decrease_ratio().when(layout="spiral"),
        lazy.layout.increase_nmaster().when(layout="tile"),
        desc="shrink ratio"
    ),
    Key([mod, "control"], "r", lazy.layout.reset(), desc="reset sizes"),

    # layout
    Key([mod], "Space", lazy.next_layout(), desc="next layout"),
    Key([mod, "shift"], "Space", lazy.previous_layout(), desc="previous layout"),
    
    # qtile
    Key(["control", "mod1"], "r", lazy.reload_config(), desc="reload config"),
    Key(["control", "mod1"], "Escape", lazy.shutdown(), desc="exit qtile"),

    # misc
    Key([mod], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod], "q", lazy.window.kill(), desc="kill"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="toggle fullscreen",
    ),

    Key([mod], "Return", lazy.spawn(terminal), desc="run terminal"),
    Key([mod], "r", lazy.spawncmd(), desc="run prompt"),
]

# virtual terminals
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# groups
for g in groups:
    keys.extend(
        [
            Key(
                [mod],
                g.name,
                lazy.group[g.name].toscreen(),
                desc="switch to group {}".format(g.name),
            ),
            Key(
                [mod, "shift"],
                g.name,
                lazy.window.togroup(g.name),
                desc="move window to group {}".format(g.name)
            ),
        ]
    )

# mouse controls
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

