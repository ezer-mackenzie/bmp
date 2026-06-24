package parser

import log "core:log"

import reader "../reader"

parse_palette :: proc (
    r: ^reader.Reader, header: BMP_Header, information_header: BMP_Information_Header
) -> (palette: []Palette, error: BMP_Error) {
    palette = make([]Palette, 0)

    information_header_size := get_size(information_header)
    bits_per_pixel := get_bits_per_pixel(information_header)

    if int(bits_per_pixel) > 8 {
        return palette, .None
    }

    palette_data_start := 14 + int(information_header_size)
    palette_size := int(header.offset_bits) - palette_data_start

    log.infof("Calculated palette size: %d bytes", palette_size)

    if palette_size <= 0 {
        return palette, .None
    }

    if palette_data_start < 0 || palette_data_start > len(r.data) {
        log.errorf("Invalid palette data start offset: %d", palette_data_start)
        return {}, .InvalidHeader
    }

    palette_data_end := palette_data_start + palette_size
    if palette_data_end > len(r.data) {
        log.errorf("Palette data truncated: expected %d bytes but only %d available", palette_size, len(r.data) - palette_data_start)
        return {}, .InvalidHeader
    }

    palette_entry_size := 4
    if information_header_size == 12 {
        palette_entry_size = 3
    }

    palette_entries := palette_size / palette_entry_size
    if palette_entries <= 0 {
        return palette, .None
    }

    if palette_entry_size == 4 {
        palette = transmute([]Palette)r.data[palette_data_start:palette_data_end]
        return palette, .None
    }

    palette = make([]Palette, palette_entries)
    for i in 0..<palette_entries {
        offset := palette_data_start + i * palette_entry_size
        palette[i] = Palette{r.data[offset + 0], r.data[offset + 1], r.data[offset + 2], 0}
    }

    log.infof("Palette parsed with %d entries", palette_entries)
    return palette, .None
}
