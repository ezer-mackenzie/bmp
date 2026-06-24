package parser

import log "core:log"

import reader "../reader"

// the `parse_header` function reads the BMP file header from the provided reader and validates it. 
// It checks if the data length is sufficient to contain the header, then extracts the header
// and validates the BMP signature. If the signature is valid, it returns the header; otherwise, it returns an appropriate error.
parse_header :: proc (r: ^reader.Reader) -> (header: BMP_Header, error: BMP_Error) {
    log.info("Reading BMP file header...");

    if len(r.data) < 14 do return {}, BMP_Error.InvalidHeader;

    header = (transmute(^BMP_Header)(&r.data[0]))^;

    validate_signature(header) or_return

    log.infof("File header: %#v", header);

    return header, BMP_Error.None;
}