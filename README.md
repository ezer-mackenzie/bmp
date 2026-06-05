# BMP Parser

A lightweight BMP parser implementation written in Odin.

## What this project does

- Parses BMP file headers and DIB information headers.
- Validates BMP signatures, offsets, image dimensions, and uncompressed pixel data.
- Supports uncompressed BMP files using `BI_RGB` compression.
- Extracts 24-bit RGB and 32-bit BGRA pixel values.
- Provides pixel access with BMP row stride and bottom-up row ordering.

## Supported formats

- DIB header sizes: `12`, `40`, `52`, `56`, `108`, `124`
- Compression: `BI_RGB` (no compression)
- Bits per pixel: `24`, `32`
- Planes: `1`

## Current limitations

- Indexed 8-bit palette BMP decoding is recognized but not implemented.
- 16-bit BMP pixel extraction is recognized but not implemented.
- Compressed BMP formats are not supported.
- No packaged CLI or installation workflow yet.

## Getting started

### Prerequisites

- Odin compiler installed.

### Run the demo

From the repository root:

```sh
odin run main.odin
```

### Add or extend tests

Test scaffolding is available in `tests/bmp/bmp_test.odin`.
Add concrete assertions and run your Odin test runner.

## Repository structure

- `main.odin` — example entry point and parser demo.
- `bmp/` — BMP parser implementation and pixel decoding.
- `reader/` — memory-mapped BMP reader utility.
- `tests/` — test scaffolding for parser behavior.
- `docs/` — design notes, audits, and implementation guides.

## License

This project is licensed under the MIT License. See `LICENSE.md`.
