package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	userProfile := os.Getenv("USERPROFILE")
	if userProfile == "" {
		fmt.Fprintln(os.Stderr, "ERROR: USERPROFILE is not set")
		os.Exit(1)
	}

	script := filepath.Join(userProfile, ".codex", "skills", "espidf-lowfat", "scripts", "invoke-idf-raw.ps1")
	args := []string{"-NoProfile", "-ExecutionPolicy", "Bypass", "-File", script}
	args = append(args, os.Args[1:]...)

	cmd := exec.Command("powershell.exe", args...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			os.Exit(exitErr.ExitCode())
		}
		fmt.Fprintf(os.Stderr, "ERROR: failed to run ESP-IDF shim: %v\n", err)
		os.Exit(1)
	}
}
