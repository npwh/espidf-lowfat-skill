# Agent Instructions

Use this repository to install and run the `espidf-lowfat` skill or its standalone lowfat ESP-IDF wrapper from any LLM coding agent.

## Purpose

This repo integrates ESP-IDF command output with upstream lowfat:

- lowfat upstream: https://github.com/zdk/lowfat
- ESP-IDF upstream: https://github.com/espressif/esp-idf

It provides filter rules and Windows scripts only. It does not include the lowfat binary.

## Fresh Windows Install

1. Install prerequisites: Git, PowerShell, Rust/Cargo, ESP-IDF.
2. Install lowfat:

```powershell
cargo install lowfat
lowfat.exe --version
```

3. Install this Codex skill, if Codex skills are supported:

```powershell
npx.cmd skills add npwh/espidf-lowfat-skill@espidf-lowfat -g -y
```

4. For non-Codex agents, clone this repo and run the wrapper installer from the clone:

```powershell
git clone https://github.com/npwh/espidf-lowfat-skill.git
powershell.exe -ExecutionPolicy Bypass -File .\espidf-lowfat-skill\espidf-lowfat\scripts\install-wrapper-mode.ps1
```

5. Verify:

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe plugin list
lowfat.exe plugin doctor
lowfat.exe rewrite "idf.py.cmd -C D:\path\to\esp-idf-project build"
```

## Agent Usage Pattern

Prefer wrapped commands when measuring token savings:

```powershell
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe stats
lowfat.exe stats --audit
```

Use helper mode when an agent needs a direct PowerShell script:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\espidf-lowfat\scripts\idf-lowfat.ps1 -ProjectPath "D:\path\to\esp-idf-project" build
```

Keep failures conservative: preserve enough raw output for the first actionable compiler, CMake, linker, flash, or monitor error.
