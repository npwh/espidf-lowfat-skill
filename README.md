# espidf-lowfat-skill

Codex skill for running ESP-IDF build, flash, monitor, and size commands through [lowfat](https://github.com/zdk/lowfat) compact output filters on Windows.

This repository provides a Codex skill, ESP-IDF filter rules, and Windows helper scripts for lowfat. It does not vendor or redistribute lowfat itself; install lowfat from the upstream project: [zdk/lowfat](https://github.com/zdk/lowfat).

## LLM Install Context

Use this section as context for another LLM or coding agent that needs to install this skill on a fresh Windows machine.

### What this repo is

- A Codex skill named `espidf-lowfat`.
- A lowfat plugin/filter for `idf.py` and `idf.py.cmd`.
- Windows PowerShell helper scripts for ESP-IDF build, flash, monitor, and size output.
- Not a fork or bundled copy of lowfat.

### Credits and upstream references

- lowfat upstream: [zdk/lowfat](https://github.com/zdk/lowfat)
- lowfat describes itself as a lightweight CLI that reduces AI token costs by filtering unnecessary CLI output before it reaches an agent.
- lowfat upstream install examples include `cargo install lowfat` and direct usage such as `lowfat git status`.
- lowfat upstream exposes `lowfat stats`, `lowfat stats --audit`, `lowfat history`, `lowfat plugin new`, and `lowfat filter` for measuring savings and authoring filters.
- ESP-IDF is Espressif's official framework for ESP32-family firmware development: [Espressif ESP-IDF](https://github.com/espressif/esp-idf)

### Prerequisites

- Windows PowerShell.
- Git.
- Node.js/npm if installing skills with `npx.cmd skills add`.
- Rust/Cargo if installing lowfat with `cargo install lowfat`.
- ESP-IDF installed and usable from PowerShell. If the ESP-IDF PowerShell profile is not auto-discovered, set:

```powershell
$env:IDF_POWERSHELL_PROFILE = "C:\path\to\Microsoft.<version>.PowerShell_profile.ps1"
```

### Install lowfat

Install lowfat from the upstream project. On Windows, Cargo is the most portable path:

```powershell
cargo install lowfat
lowfat.exe --version
```

If your Windows security policy blocks locally built binaries, sign or allow the `lowfat.exe` binary according to your local organization policy. Do not disable system-wide security just for this tool.

### Install this skill

```powershell
npx.cmd skills add npwh/espidf-lowfat-skill@espidf-lowfat -g -y
```

Alternative Codex installer:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" --repo npwh/espidf-lowfat-skill --path espidf-lowfat
```

### Install ESP-IDF lowfat wrapper mode

Run this after installing the skill:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\install-wrapper-mode.ps1"
```

That script:

- Sets user `LOWFAT_HOME` to `%USERPROFILE%\.lowfat`.
- Installs the ESP-IDF lowfat plugin under `%USERPROFILE%\.lowfat\plugins`.
- Installs `idf.py.cmd` and `idf.cmd` shims under `%USERPROFILE%\.cargo\bin` by default.

### Verify installation

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe plugin list
lowfat.exe plugin doctor
lowfat.exe plugin info esp-idf-compact
lowfat.exe rewrite "idf.py.cmd -C D:\path\to\esp-idf-project build"
```

Expected plugin names include:

- `esp-idf-compact` for `idf.py` / `idf.py.cmd`
- `esp-idf-wrapper-compact` for `idf`

### Run and measure token savings

Use wrapper mode when you want lowfat to record savings:

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe stats
lowfat.exe stats --audit
```

Use helper mode when you want a direct PowerShell wrapper around ESP-IDF:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\idf-lowfat.ps1" -ProjectPath "D:\path\to\esp-idf-project" build
```

### Troubleshooting

- If `lowfat stats` says no data yet, the command was not run through `lowfat.exe <command...>`.
- If `lowfat plugin list` does not show ESP-IDF plugins, check `LOWFAT_HOME`.
- If `idf.py.cmd` is missing, rerun `scripts/install-wrapper-mode.ps1`.
- If ESP-IDF profile discovery fails, pass `-ProfilePath` or set `IDF_POWERSHELL_PROFILE`.
- Use `lowfat.exe stats --audit` to confirm which commands lowfat actually wrapped.

## Install

```powershell
npx.cmd skills add npwh/espidf-lowfat-skill@espidf-lowfat -g -y
```

Or with the Codex skill installer:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py" --repo npwh/espidf-lowfat-skill --path espidf-lowfat
```

## Use

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project size
lowfat.exe stats
```

For helper mode:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\idf-lowfat.ps1" -ProjectPath "D:\path\to\esp-idf-project" build
```

The skill itself lives in [`espidf-lowfat/`](espidf-lowfat/).
