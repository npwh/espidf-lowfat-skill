# Credits

This repository is a small integration layer for using lowfat with ESP-IDF workflows on Windows.

## Upstream Projects

### lowfat

- Project: `zdk/lowfat`
- URL: https://github.com/zdk/lowfat
- Role in this repository: command-output compaction, lowfat plugin/filter runtime, and token-savings measurement commands such as `lowfat stats` and `lowfat stats --audit`.
- Relationship: this repository depends on users installing lowfat separately. It does not vendor, fork, or redistribute the lowfat binary or source code.

### ESP-IDF

- Project: `espressif/esp-idf`
- URL: https://github.com/espressif/esp-idf
- Role in this repository: target firmware development framework and command family for `idf.py`, build, flash, monitor, size, and related ESP32 workflows.
- Relationship: this repository provides helper scripts and lowfat filters for ESP-IDF output. It does not vendor, fork, or redistribute ESP-IDF.

## Repository Scope

Original work in this repository includes:

- ESP-IDF-focused lowfat filter rules.
- Windows PowerShell wrapper scripts.
- Codex-compatible skill metadata.
- Agent install documentation for Codex, Claude Code, Pi, aider, Cursor-style agents, CI agents, and generic shell agents.

## Attribution Style

When referencing this project, please preserve upstream credit for both lowfat and ESP-IDF:

```text
Uses espidf-lowfat-skill by npwh, an integration layer for zdk/lowfat and Espressif ESP-IDF.
lowfat: https://github.com/zdk/lowfat
ESP-IDF: https://github.com/espressif/esp-idf
```

