from libqtile import bar, widget
from qtile_extras.popup.toolkit import (
    PopupRelativeLayout,
    PopupText
)

class BarPopout(widget.base._TextBox):
    def __init__(self, step, interval, layout, **config):
        super().__init__("", **config)

        layout.close_on_click = False

        self.step = step
        self.interval = interval
        self.progress = 0
        self.target = layout.height

        self.playout = layout
        self.toggled = False
        self.text = "woa!"

        self.add_callbacks({
            "Button1": self.toggle
        })

    def _configure(self, qtile, bar):
        super()._configure(qtile, bar)
        self.playout.width = self.bar.width

        if not self.configured:
            self.playout._configure(qtile)

    def toggle(self):
        self.toggled = not self.toggled
        if self.progress == 0:
            self.animate()

    def animate(self):
        self.progress = min(self.progress + self.step, 1)
        self.show()

        if self.progress != 1:
            self.timeout_add(self.interval, self.animate)
        else:
            self.progress = 0

    def show(self):
        if self.toggled:
            progress = self.progress
        else:
            progress = 1 - self.progress

        height = int(self.target * progress)
        self.playout.show(0, self.target - height, relative_to=7)
        self.bar.margin[2] = height
        self.bar._configure(self.qtile, self.bar.screen, reconfigure=True)


text = PopupText(
    text="woaoawhrioahnuiowafnaouilnaoilar",
    height=1,
    width=1
)

menu_layout = PopupRelativeLayout(
    None,
    height=64,
    controls=[text]
)

widget = bar.Bar(
    [
        widget.CurrentLayout(),
        BarPopout(0.085, 0.015, menu_layout),
        widget.GroupBox(disable_drag=True),
        widget.Prompt(),
        widget.WindowName(format='{class}'),
        widget.Clock(format="%I:%M%P"),
    ],
    32,
    margin=[0, 0, 0, 0]
)

