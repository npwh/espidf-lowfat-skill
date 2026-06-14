package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	exe, err := os.Executable()
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: cannot resolve executable path: %v\n", err)
		os.Exit(1)
	}

	script := filepath.Join(filepath.Dir(exe), "invoke-idf-raw.ps1")
	if _, err := os.Stat(script); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: invoke-idf-raw.ps1 not found next to shim: %v\n", err)
		os.Exit(1)
	}

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
