# Contributing

Thanks for improving `espidf-lowfat-skill`.

This project is a small integration layer around upstream lowfat and ESP-IDF:

- lowfat: https://github.com/zdk/lowfat
- ESP-IDF: https://github.com/espressif/esp-idf

## Before Opening An Issue

Please include:

- Windows version and PowerShell version.
- ESP-IDF version.
- `lowfat.exe --version`.
- Whether you used Codex skill install or the generic clone-and-run flow.
- The command you ran, with private project paths and secrets removed.
- The smallest log sample that still shows the issue.

Do not include Wi-Fi credentials, API tokens, device secrets, customer logs, or private firmware.

## Development Checks

Run these before sending a pull request:

```powershell
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" ".\espidf-lowfat"
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe plugin doctor
lowfat.exe rewrite "idf.py.cmd -C D:\path\to\esp-idf-project build"
```

If you change filter behavior, include a before/after summary showing which important ESP-IDF lines are preserved and how much output is reduced.

