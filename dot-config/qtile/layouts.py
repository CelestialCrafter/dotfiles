from libqtile import layout
from libqtile.config import Match
from theme import layout_defaults

layouts = [
    layout.Spiral(**layout_defaults),
    layout.Tile(**layout_defaults),
    layout.Max(**layout_defaults),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
