# Security Policy

## Supported Versions

The latest `main` branch and tagged releases are supported.

## Reporting a Vulnerability

Open a GitHub issue with a clear description and reproduction steps. Do not include secrets, access tokens, private firmware, or proprietary logs in public issues.

## Local Security Notes

- This repository does not vendor or redistribute `lowfat`; install it from the upstream project: https://github.com/zdk/lowfat
- Do not disable Windows security features to run locally built tools.
- If Windows Application Control blocks a locally built `lowfat.exe`, sign or allow the binary according to your organization's local policy.
- Treat ESP-IDF serial logs as potentially sensitive. Sanitize Wi-Fi credentials, device IDs, tokens, endpoints, and customer data before sharing logs.
