from qtile_extras.layout.decorations import RoundedCorners

colors = dict(
    background="#030c21",
    overlay="#000000",
    muted="#676d7a",
    text="#e3ebfc",
    primary="#7e3035",
    secondary="#e47622",
    accent="#f3c477"
)

slurp_theme = f'-b{colors["background"]}aa -c{colors["primary"]}ff'

layout_defaults = dict(
    # ew... "colour"
    border_normal=RoundedCorners(colour=colors["muted"]),
    border_focus=RoundedCorners(colour=colors["primary"]),
    border_width=2,
    margin=4
)

widget_defaults = dict(
    font="sans",
    fontsize=14,
    padding=4,
)

extension_defaults = widget_defaults.copy()

