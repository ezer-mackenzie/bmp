package parser

import log "core:log"

import reader "../reader"

// the `bmp_parse_information_header` function reads the BMP information header from the provided reader and validates it. 
// It checks if the data length is sufficient to contain the header, then extracts the information header and checks for unsupported compression types. 
// If everything is valid, it returns the information header; otherwise, it returns an appropriate error.
parse_information_header :: proc (r: ^reader.Reader) -> (information_header: BMP_Information_Header, error: BMP_Error) {
    log.info("Reading BMP information header...")

    if len(r.data) < 18 {
        return {}, BMP_Error.InvalidHeader
    }

    size := (cast(^u32)(&r.data[14]))^
    version := get_version(size) or_return

    information_header = get_information_header(r, version) or_return

    validate_information_header(information_header)

    return information_header, .None
}

get_information_header:: proc(
    r: ^reader.Reader, version: BMP_Version
) -> (information_header: BMP_Information_Header, error: BMP_Error){
    switch version {
    case .Core:
        information_header = (cast(^BMP_Info_Core_Header)(&r.data[14]))^

    case .OS2_2X_Short:
        information_header = (cast(^BMP_Info_OS2_2X_Short_Header)(&r.data[14]))^

    case .Info:
        information_header = (cast(^BMP_Info_Header)(&r.data[14]))^

    case .V2:
        information_header = (cast(^BMP_Info_V2_Header)(&r.data[14]))^

    case .V3:
        information_header = (cast(^BMP_Info_V3_Header)(&r.data[14]))^

    case .OS2_2X:
        information_header = (cast(^BMP_Info_OS2_2X_Header)(&r.data[14]))^

    case .V4:
        information_header = (cast(^BMP_Info_V4_Header)(&r.data[14]))^

    case .V5:
        information_header = (cast(^BMP_Info_V5_Header)(&r.data[14]))^

    case .Invalid:
        log.errorf("Unsupported Version: %d", version)
        return {}, .InvalidHeader
    }

    return information_header, BMP_Error.None
}

validate_information_header:: proc(information_header: BMP_Information_Header) -> (error: BMP_Error){
    compresion, err_compresion := get_compression(information_header)

    bits_per_pixel := get_bits_per_pixel(information_header)
    planes := get_planes(information_header)
    width := get_width(information_header)
    height := get_height(information_header)

    if err_compresion != .None {
        validate_compression(compresion) or_return
    }
    
    validate_bits_per_pixel(bits_per_pixel) or_return
    validate_planes(planes) or_return
    validate_dimensions(width, height) or_return

    log.infof("Information header: %#v", information_header)

    return .None
}

