package parser

import log "core:log"

get_version :: proc(size: u32) -> (version: BMP_Version, error: BMP_Error) {
    version = BMP_Version.Invalid

    switch size {
        case 12:
            version = .Core
        case 64:
            version = .OS2_2X
        case 16:
            version = .OS2_2X_Short
        case 40:
            version = .Info
        case 52:
            version = .V2
        case 56:
            version = .V3
        case 108:
            version = .V4
        case 124:
            version = .V5
    }

    if version == .Invalid {
        log.errorf("unsupported BMP version size=%d", size)
        return .Invalid, BMP_Error.UnsupportedVersion
    }

    log.info("BMP version: %v", version)
    return version, nil
}



get_palette_size:: proc(information_header: BMP_Information_Header) -> (palette_size: int){
    bpp := get_bits_per_pixel(information_header)

    if bpp > 8 {
        return 0
    }

    return 1 << bpp
}

get_row_stride:: proc(width: i32, bits_per_pixel: u16) -> u32 {
    bits_per_row := u32(width) * u32(bits_per_pixel)

    return ((bits_per_row + 31) / 32) * 4
}

get_pixel_array_size:: proc(width: i32, height: i32, bits_per_pixel: u16) -> u32 {
    stride := get_row_stride(width, bits_per_pixel)

    return stride * u32(abs(height))
}
