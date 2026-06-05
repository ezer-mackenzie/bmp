# Security Policy

If you discover a security vulnerability in this repository, please report it responsibly.

## Reporting a vulnerability

1. Open a GitHub issue and clearly label it `security` if possible.
2. Include the following information when available:
   - A description of the issue.
   - Steps to reproduce.
   - Example BMP file or sample data, if applicable.
   - The environment used to reproduce the issue.

## Disclosure

- Do not publish proof-of-concept details publicly until a fix is available.
- If GitHub security advisories are available for this repository, use that channel.
- Otherwise, open a private issue or contact the maintainers directly.

## Response expectations

Maintainers will acknowledge security reports as soon as possible, typically within one week.

## Scope

This repository is a BMP parsing implementation for Odin. Vulnerabilities may include:
- malformed BMP input handling
- out-of-bounds parsing
- memory safety issues in parser logic
