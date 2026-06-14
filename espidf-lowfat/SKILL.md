---
name: espidf-lowfat
description: Run ESP-IDF idf.py build, flash, monitor, and related firmware commands with compact lowfat output on Windows PowerShell. Use when working on ESP32/ESP-IDF projects and the user wants less noisy build logs, flash logs, serial monitor logs, Blynk/MQTT/Wi-Fi/device logs, or asks to use lowfat with ESP-IDF.
---

# ESP-IDF Lowfat

Use this skill to run ESP-IDF commands through [lowfat](https://github.com/zdk/lowfat) while preserving firmware debugging signal and removing noisy CMake, Ninja, esptool, Wi-Fi init, and serial chatter.

This skill is an integration for the upstream lowfat project, not a replacement for it. Install and update lowfat from [zdk/lowfat](https://github.com/zdk/lowfat).

## Credits And Install Context

- Credit upstream lowfat: [zdk/lowfat](https://github.com/zdk/lowfat).
- Credit Espressif ESP-IDF: [espressif/esp-idf](https://github.com/espressif/esp-idf).
- lowfat upstream install example: `cargo install lowfat`.
- lowfat direct usage pattern: `lowfat <command>`, for example `lowfat git status`.
- lowfat savings commands: `lowfat stats`, `lowfat stats --audit`, and `lowfat history`.
- This skill only provides ESP-IDF-specific filter rules, shims, and helper scripts; it does not vendor lowfat.

For a fresh Windows setup, install lowfat first, then install this skill, then run `scripts/install-wrapper-mode.ps1` to install the ESP-IDF plugin and shims.

## Quick Start

For lowfat wrapper mode with stats/history, use:

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
```

Use `idf.py.cmd` because Windows PowerShell normally exposes `idf.py` as an alias, not as an executable that lowfat can wrap reliably.

Prefer the bundled helper:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\idf-lowfat.ps1" -ProjectPath "D:\path\to\esp-idf-project" build
```

For flash:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\idf-lowfat.ps1" -ProjectPath "D:\path\to\esp-idf-project" -IdfArgs @("-p","COMx","flash")
```

For concise serial monitor output:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\idf-lowfat.ps1" -ProjectPath "D:\path\to\esp-idf-project" -IdfArgs @("-p","COMx","monitor")
```

## Workflow

1. Use `scripts/idf-lowfat.ps1` instead of calling `idf.py` directly when output will be long.
2. Pass the ESP-IDF project path with `-ProjectPath`.
3. Pass normal `idf.py` arguments after the script, or with `-IdfArgs @(...)` when arguments include options such as `-p COMx`.
4. Use `-Level ultra` for very short output, `-Level full` by default, and `-Level lite` when broader context is useful.
5. On command failure, keep output conservative and include enough error context to debug.

For wrapper mode, first run `scripts/install-wrapper-mode.ps1` if `where.exe idf.py.cmd` does not find the shim. Then run commands from any directory with `-C`, or from inside the ESP-IDF project directory without `-C`:

```powershell
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project -p COMx flash
```

Set `LOWFAT_HOME` to `$env:USERPROFILE\.lowfat` so lowfat can find installed plugins. If a Codex hook is used, make the hook set `LOWFAT_HOME` before invoking lowfat.

## What The Filter Keeps

- Compiler warnings/errors, linker failures, fatal errors, and missing Kconfig warnings
- Build summaries, binary sizes, app partition free space, and generated artifact paths
- Flash port, chip, MAC, write verification, reset, and flash failures
- Serial lines involving `BLYNK_MANAGER`, `DEVICE_MANAGER`, `MQTT`, `Wi-Fi`, `Unhandled`, warnings, errors, panic, backtrace, and reset

## Verification

Run these after changing the filter, wrapper, or lowfat binary:

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe plugin list
lowfat.exe plugin doctor
lowfat.exe plugin info esp-idf-compact
lowfat.exe rewrite "idf.py.cmd -C D:\path\to\esp-idf-project build"
```

Known-good sample result: the bundled ESP-IDF sample filtered from `388` tokens to `129` tokens, about `66.8%` saved, while preserving CMake warning lines, generated `.bin`, binary size, and `Project build complete`.

If Windows Application Control blocks `lowfat.exe`, verify its signature:

```powershell
Get-AuthenticodeSignature "$env:USERPROFILE\.cargo\bin\lowfat.exe"
```

If your organization requires signed binaries, sign the locally built `lowfat.exe` according to your local security policy after reinstalling or overwriting it.

## Bundled Resources

- `scripts/idf-lowfat.ps1`: Windows PowerShell helper that loads ESP-IDF, installs the lowfat ESP-IDF filter if needed, runs `idf.py`, and filters output.
- `scripts/install-wrapper-mode.ps1`: Installs the lowfat plugin and `idf.py.cmd` shim for wrapper mode.
- `scripts/invoke-idf-raw.ps1`: Raw ESP-IDF command runner used by the wrapper shim.
- `references/esp-idf-compact.filter.lf`: lowfat filter rules used by the helper and installed to `~\.lowfat\plugins\idf.py\esp-idf-compact`.

Read the filter file only when editing lowfat rules.
