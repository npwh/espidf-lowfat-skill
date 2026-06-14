# Custom Filters

You can add or customize lowfat filters for your own ESP-IDF projects.

## Filter Locations

Bundled source filter:

```text
espidf-lowfat/references/esp-idf-compact.filter.lf
```

Installed plugin copies:

```text
%USERPROFILE%\.lowfat\plugins\idf.py\esp-idf-compact\filter.lf
%USERPROFILE%\.lowfat\plugins\idf\esp-idf-wrapper-compact\filter.lf
```

Edit the bundled filter when contributing back to this repo. Edit the installed plugin copy for a local machine override.

## What To Keep

Preserve:

- Compiler errors and warnings.
- CMake, Ninja, and linker failures.
- Flash port, chip, MAC, write, verify, reset, and flash failure lines.
- Firmware panics, aborts, resets, backtraces, and fatal errors.
- Final build summaries, binary sizes, and generated artifact paths.
- Project-specific tags that matter to your debugging flow.

Common project tags include:

```text
MQTT
BLYNK
OTA
SENSOR
DEVICE_MANAGER
PROVISION
WIFI
BLE
```

## Suggested Workflow

1. Copy the current filter before editing.
2. Add rules for your important component tags.
3. Test quickly with:

```powershell
lowfat.exe filter ".\espidf-lowfat\references\esp-idf-compact.filter.lf"
```

4. Test with a real wrapped ESP-IDF command:

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe stats --audit
```

5. If the filter hides useful debugging signal, make it more conservative.

## Agent Guidance

When an LLM agent edits filters, it should optimize for preserving debugging signal first and token savings second. A smaller log is only useful if it still keeps the first actionable failure and the final command status.
