package parser

import log "core:log"

import reader "../reader"


parser_bmp :: proc (r: ^reader.Reader) -> (bmp: BMP, error: BMP_Error) {
    log.infof("Initializing BMP reader with data of length %d bytes", len(r.data));

    header := parse_header(r) or_return
    information_header := parse_information_header(r) or_return

    size := get_size(information_header)
    version := get_version(size) or_return
    image_size := get_image_size(information_header) or_return

    validate_offset_bits(header, len(r.data)) or_return
    validate_header_image_size(header.offset_bits, image_size, len(r.data)) or_return

    pixel_data := r.data[header.offset_bits:]
    palette_size := int(header.offset_bits) - (14 + int(size))

    palette, err_palette := parse_palette(r, header, information_header)

    log.infof("Calculated palette size: %d bytes", palette_size)

    bmp = BMP{
        header,
        information_header,
        version,
        palette,
        pixel_data,
    };

    log.infof("Offset to pixel data: %d bytes is equals to %d", header.offset_bits, len(r.data) - int(header.offset_bits));
    log.infof("Offset express validation value: %d", len(r.data) - int(header.offset_bits));
    log.infof("File size length: %d bytes equals to %d", header.file_size, len(r.data));
    log.info("BMP initialized successfully.");

    return bmp, BMP_Error.None;
}


