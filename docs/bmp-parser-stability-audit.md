# BMP Parser Stability Audit

## Summary

This repository currently implements a basic BMP parser in Odin with the following capabilities:

- BMP file header parsing and validation.
- DIB information header parsing for several header sizes.
- Validation of signature, compression, bits per pixel, planes, dimensions, and pixel offset.
- Pixel extraction for 24-bit RGB and 32-bit BGRA images.
- A simple memory-mapped reader layer in `reader/reader.odin`.

The parser is not yet stable for a full library release because it leaves several BMP variants unimplemented and relies on unsafe field transmutation for header parsing.

## Current state of the library

### Working behavior

- `bmp/bmp.odin` parses BMP headers and information headers.
- `bmp_validate_compression` only accepts `BI_RGB`.
- `bmp_validate_bits_per_pixel` accepts `8`, `16`, `24`, and `32`, but only 24-bit and 32-bit pixel extraction is actually implemented.
- `bmp_get_pixel` supports 24-bit and 32-bit output and handles bottom-up BMP row order.
- The library can read from a file using `reader.reader_initialize` and return a `BMP` struct.

### Visible gaps

- Palette parsing for indexed BMPs is not implemented. The code currently returns an empty palette and does not use it.
- 8-bit indexed BMP support is missing despite being accepted by `bmp_validate_bits_per_pixel`.
- 16-bit BMP extraction is not implemented; the code currently rejects unsupported bit depths only in pixel access.
- Compression is not supported beyond `BI_RGB`.
- `bmp_parse_information_header` uses `transmute(^Information_Header)` for all supported header sizes, which is unsafe for headers smaller or larger than the `Information_Header` struct size.
- There is no targeted test coverage for specific BMP versions, bit depths, or malformed input.
- `main.odin` is a demo script, not a library entry point; it should be moved to an example or CLI if the library is packaged.

## Stability risks and blocking issues

### Unsafe header parsing

The biggest stability risk is the use of `transmute(^Information_Header)` on raw bytes for variable-sized DIB headers.

- `Information_Header` is fixed at 40 bytes.
- The parser also accepts header sizes `12`, `52`, `56`, `108`, and `124`.
- This means headers of different size are being interpreted through the same struct layout, which is not safe or correct.

### Partial or missing feature implementation

- `palette_size` is calculated but palette parsing is not implemented.
- 8-bit palettes, 4-bit and 1-bit bitfields, and 16-bit color formats are missing.
- The code logs warnings for unsupported compression rather than offering clear conversion or fallback logic.

### Error handling and return values

- Some functions return empty structs plus an error code, which is okay, but the code contains TODO comments around error handling that should be cleaned up.
- `bmp_get_pixel` returns an empty `Color` on out-of-bounds access; this should be consistent with the library error model.

### Testing coverage

- `tests/bmp/bmp_test.odin` contains scaffolding but no actual assertions.
- There are no unit tests covering header parsing, invalid files, palette BMPs, or compression edge cases.

## Recommended refactors for stability

### 1. Replace `transmute` with explicit field parsing

Create a small reader helper API for reading values from bytes safely, for example:

- `reader.read_u16()`
- `reader.read_u32()`
- `reader.read_i32()`
- `reader.read_bytes(count)`

Then parse headers field-by-field instead of transmuting a pointer.

### 2. Introduce explicit DIB header variants

Instead of one `Information_Header` struct for all header sizes, define separate structs or parsing code for:

- `BITMAPCOREHEADER` (12 bytes)
- `BITMAPINFOHEADER` (40 bytes)
- `BITMAPV2INFOHEADER` / `BITMAPV3INFOHEADER` if needed
- `BITMAPV4HEADER` (108 bytes)
- `BITMAPV5HEADER` (124 bytes)

This will allow correct field interpretation and safe handling of optional metadata.

### 3. Implement palette parsing and indexed color support

- Parse the palette block when `bits_per_pixel <= 8`.
- Support 1-bit, 4-bit, and 8-bit indexed BMP images.
- Return a populated `palette` field in `BMP`.

### 4. Support 16-bit and 32-bit bit-fields

- Add support for `BI_BITFIELDS` / `BI_ALPHABITFIELDS`.
- Implement proper 16-bit pixel decoding for RGB565, RGB555, ARGB1555, and similar masks.
- Clarify how alpha is handled for 32-bit BGRA images.

### 5. Strengthen compression handling

For a stable parser, at minimum support:

- `BI_RGB` (uncompressed)
- `BI_BITFIELDS` / `BI_ALPHABITFIELDS`

Later you can add RLE support:

- `BI_RLE8`
- `BI_RLE4`
- `BI_RLE24`

### 6. Clean up API and module boundaries

- Consider removing `bmp_initialize` if it only wraps `bmp_parser`.
- Move `main.odin` into `examples/` or a separate CLI package if the repository is intended to ship as a library.
- Document the public API clearly and keep parser internals separate from examples.

### 7. Improve test harness and sample assets

- Add deterministic tests for each BMP variant.
- Add invalid and boundary-case sample files.
- Ensure tests cover:
  - header size parsing
  - compression validation
  - palette decoding
  - top-down vs bottom-up BMP images
  - bit depth edge cases
  - malformed file handling

## Recommendations for an eventual stable release

### Minimum viable stable support

To call this library stable, it should reliably support:

- BMP file format headers for all common DIB versions.
- Uncompressed BMP rendering for 1-, 4-, 8-, 16-, 24-, and 32-bit images.
- Indexed color palettes and palette-based lookup.
- Safe parsing without undefined behavior from direct memory transmutation.
- Clear error codes and no silent failures.
- Adequate test coverage for both valid and invalid BMP files.

### Target release scope

If you want the parser to support "all versions," start with these goals:

1. Correct DIB header parsing for `12`, `40`, `52`, `56`, `108`, and `124`.
2. Proper palette handling for indexed BMPs.
3. Full 16-bit support with color masks.
4. Stable 24-bit and 32-bit output with correct row padding and orientation.
5. Robust size and offset validation.

### API and packaging

- Keep the parser core small and reusable.
- Add an example CLI or separate demo instead of shipping `main.odin` as the library entry.
- Document supported formats explicitly in `README.md`.
- Add a `CHANGELOG` or release notes once the parser becomes stable.
