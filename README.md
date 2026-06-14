# espidf-lowfat-skill

Codex skill for running ESP-IDF build, flash, monitor, and size commands through lowfat compact output filters on Windows.

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
