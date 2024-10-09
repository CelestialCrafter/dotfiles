package main

import (
	"fmt"
	"math"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

var rose = lipgloss.NewStyle().Foreground(lipgloss.Color("6"))
var gold = lipgloss.NewStyle().Foreground(lipgloss.Color("3"))
// rose pine muted
var muted = lipgloss.NewStyle().Foreground(lipgloss.Color("#9893a5"))
var bold = lipgloss.NewStyle().Bold(true)

var point = gold.Render("┨  ")
var sectionSep = muted.Render("―")
var dataSep = "."
var width = 30

func sep(width int, char string, key string, value string) string {
	amount := width - len(key) - len(value)
	return key + strings.Repeat(char, int(math.Max(float64(amount), 0))) + value
}

func info() string {
	// general
	name := "celestial"
	distro := "nixos"
	general := bold.Render(rose.Render(sep(width + 3, " ", name, distro))) + "\n\n"

	// hardware
	cpu := "intel 12600k"
	gpu := "nvidia 3060 ti"
	ram := "ddr5 32gb"
	hardware :=  fmt.Sprintf(
		"%s\n" + strings.Repeat("%s%s\n", 3) + "\n",
		rose.Render(sep(width + 2, sectionSep, "hardware ", "")),
		point, bold.Render(sep(width, dataSep, "cpu", cpu)),
		point, bold.Render(sep(width, dataSep, "gpu", gpu)),
		point, bold.Render(sep(width, dataSep, "ram", ram)),
	)

	wm := "river"
	editor := "neovim"
	browser := "floorp"
	font := "azuki font"
	software := fmt.Sprintf(
		"%s\n" + strings.Repeat("%s%s\n", 4) + "\n",
		rose.Render(sep(width + 2, sectionSep, "software ", "")),
		point, bold.Render(sep(width, dataSep, "wm", wm)),
		point, bold.Render(sep(width, dataSep, "editor", editor)),
		point, bold.Render(sep(width, dataSep, "browser", browser)),
		point, bold.Render(sep(width, dataSep, "font", font)),
	)

	return lipgloss.NewStyle().Padding(1).Render(general + hardware + software)
}
