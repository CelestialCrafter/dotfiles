from libqtile import bar, widget

widget = bar.Bar(
    [
        widget.CurrentLayout(),
        widget.GroupBox(disable_drag=True),
        widget.Prompt(),
        widget.WindowName(format='{class}'),
        widget.Clock(format="%I:%M%P"),
    ],
    24,
)
