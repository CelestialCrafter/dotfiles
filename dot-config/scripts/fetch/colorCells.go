package main

import (
	"strconv"

	"github.com/charmbracelet/lipgloss"
)

var baseCell = lipgloss.
	NewStyle().
	Width(10).
	Bold(true).
	AlignHorizontal(lipgloss.Center)

func cell(color lipgloss.Color) (lipgloss.Style, lipgloss.Style) {
	bgCell := baseCell.Background(color)
	fgCell := baseCell.Foreground(color)

	return bgCell, fgCell
}

func mergedCells(cells []string) string {

	style := lipgloss.
		NewStyle().
		Padding(1).
		Render(lipgloss.JoinVertical(lipgloss.Top, cells...))

	return style
}

func colorCells() string {
	colorNames := [6]string{
		"love",
		"pine",
		"gold",
		"foam",
		"iris",
		"rose",
	}

	colors := make([]lipgloss.Color, len(colorNames))
	bgCells := make([]string, len(colors))
	fgCells := make([]string, len(colors))

	for i := range colors {
		colors[i] = lipgloss.Color(strconv.Itoa(i + 1))
	}

	for i, color := range colors {
		name := colorNames[i]
		bgCell, fgCell := cell(color)

		bgCells[i] = bgCell.Render(name)
		fgCells[i] = fgCell.Render(name)
	}

	colorCells := lipgloss.JoinHorizontal(
		lipgloss.Left,
		mergedCells(bgCells),
		mergedCells(fgCells),
	)

	return colorCells
}


