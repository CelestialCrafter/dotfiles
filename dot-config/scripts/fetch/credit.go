package main

import (
	"fmt"

	"github.com/charmbracelet/lipgloss"
)

func credit() string {
	heart := lipgloss.NewStyle().Foreground(lipgloss.Color("6")).Render("┻ ")
	style := lipgloss.NewStyle().Padding(1)
	return style.Render(fmt.Sprintf(
		"%s\n%s",
		"all art by よしだのえる",
		heart + " made by celestial " + heart,
	))
}
