# LLM Agent Install Guide

This guide is for any LLM coding agent that needs to install and use `espidf-lowfat-skill` on Windows, even when the agent does not support Codex skills.

## Upstream Credit

- lowfat: https://github.com/zdk/lowfat
- ESP-IDF: https://github.com/espressif/esp-idf

This repo provides filter rules, scripts, and skill metadata only. It does not vendor the lowfat binary or ESP-IDF.

## Universal Install Flow

Run these commands from Windows PowerShell:

```powershell
cargo install lowfat
lowfat.exe --version
git clone https://github.com/npwh/espidf-lowfat-skill.git
powershell.exe -ExecutionPolicy Bypass -File ".\espidf-lowfat-skill\espidf-lowfat\scripts\install-wrapper-mode.ps1"
```

Verify:

```powershell
$env:LOWFAT_HOME = "$env:USERPROFILE\.lowfat"
lowfat.exe plugin list
lowfat.exe plugin doctor
lowfat.exe rewrite "idf.py.cmd -C D:\path\to\esp-idf-project build"
```

Run ESP-IDF through lowfat:

```powershell
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project size
lowfat.exe stats --audit
```

## Codex Skill Install

Use this only if the host supports Codex-compatible skills:

```powershell
npx.cmd skills add npwh/espidf-lowfat-skill@espidf-lowfat -g -y
powershell.exe -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\espidf-lowfat\scripts\install-wrapper-mode.ps1"
```

## Claude Code Hook

This repo does not require Claude Code, but Claude Code can run upstream lowfat as a hook. In `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "lowfat hook" }]
      }
    ]
  }
}
```

For ESP-IDF commands on Windows, still prefer:

```powershell
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
```

## Pi, Aider, Cursor-Style, Or Unknown Agents

Use the universal clone-and-run flow. If the agent can execute PowerShell, it can use this repo without Codex.

If the agent cannot discover ESP-IDF automatically, set:

```powershell
$env:IDF_POWERSHELL_PROFILE = "C:\path\to\Microsoft.<version>.PowerShell_profile.ps1"
```

or pass `-ProfilePath` to `idf-lowfat.ps1`.

## Agent Prompt

Paste this into any LLM agent:

```text
Install and use https://github.com/npwh/espidf-lowfat-skill on Windows.
Credit upstream lowfat at https://github.com/zdk/lowfat and ESP-IDF at https://github.com/espressif/esp-idf.
If Codex-compatible skills are supported, run:
npx.cmd skills add npwh/espidf-lowfat-skill@espidf-lowfat -g -y
Otherwise run:
cargo install lowfat
git clone https://github.com/npwh/espidf-lowfat-skill.git
powershell.exe -ExecutionPolicy Bypass -File ".\espidf-lowfat-skill\espidf-lowfat\scripts\install-wrapper-mode.ps1"
Then use:
lowfat.exe idf.py.cmd -C D:\path\to\esp-idf-project build
lowfat.exe stats --audit
```
