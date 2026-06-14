# espidf-lowfat-skill

Codex skill for running ESP-IDF build, flash, monitor, and size commands through lowfat compact output filters on Windows.

## Install

```powershell
npx.cmd skills add npwh/espidf-lowfat-skill@espidf-lowfat -g -y
```

Or with the Codex skill installer:

```powershell
python C:\Users\NPWH\.codex\skills\.system\skill-installer\scripts\install-skill-from-github.py --repo npwh/espidf-lowfat-skill --path espidf-lowfat
```

## Use

```powershell
$env:LOWFAT_HOME = "C:\Users\NPWH\.lowfat"
lowfat.exe idf.py.cmd -C D:\espidf\github\esp32-blynk build
lowfat.exe idf.py.cmd -C D:\espidf\github\esp32-blynk size
lowfat.exe stats
```

The skill itself lives in [`espidf-lowfat/`](espidf-lowfat/).
