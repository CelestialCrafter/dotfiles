package main

import (
	"fmt"
	"strings"

	"github.com/charmbracelet/lipgloss"
	"golang.org/x/term"
)

var padding = 2
var promptHeight = 1

func main() {
	// sry in advance, this was rlly sloppily and quickly thrown together
	// still looks cute tho ;3

	termWidth, termHeight, err := term.GetSize(0)
	if err != nil {
		panic(err)
	}

	rightPadded := lipgloss.NewStyle().PaddingRight(padding)
	leftPadded := lipgloss.NewStyle().PaddingLeft(padding)

	infoBlock := rightPadded.Render(info())
	colorBlock := leftPadded.Render(colorCells())
	creditBlock := leftPadded.Render(credit())

	creditBlockHeight := lipgloss.Height(infoBlock) - lipgloss.Height(colorBlock) - strings.Count(creditBlock, "\n") + 1
	creditBlock = lipgloss.PlaceVertical(creditBlockHeight, lipgloss.Bottom, creditBlock)

	merged := lipgloss.JoinVertical(lipgloss.Top, colorBlock, creditBlock)
	merged = lipgloss.JoinHorizontal(lipgloss.Top, infoBlock, merged)

	output := lipgloss.Place(termWidth, termHeight - promptHeight, lipgloss.Center, lipgloss.Center, merged)

	fmt.Println(output)
}
