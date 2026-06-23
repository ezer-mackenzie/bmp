package bmp

get_size:: proc(information_header: BMP_Information_Header) -> (size: u32){
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return ih.size

    case BMP_Info_OS2_2X_Header:
        return ih.size

    case BMP_Info_OS2_2X_Short_Header:
        return ih.size

    case BMP_Info_Header:
        return ih.size

    case BMP_Info_V2_Header:
        return ih.size

    case BMP_Info_V3_Header:
        return ih.size

    case BMP_Info_V4_Header:
        return ih.size

    case BMP_Info_V5_Header:
        return ih.size

    case:
        return 0
    }
}

get_width :: proc(information_header: BMP_Information_Header) -> (version: i32) {
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return i32(ih.width)

    case BMP_Info_OS2_2X_Header:
        return ih.width

    case BMP_Info_OS2_2X_Short_Header:
        return ih.width

    case BMP_Info_Header:
        return ih.width

    case BMP_Info_V2_Header:
        return ih.width

    case BMP_Info_V3_Header:
        return ih.width

    case BMP_Info_V4_Header:
        return ih.width

    case BMP_Info_V5_Header:
        return ih.width
    }
    
    return 0
}

get_height :: proc(information_header: BMP_Information_Header) -> i32 {
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return i32(ih.height)

    case BMP_Info_OS2_2X_Header:
        return ih.height

    case BMP_Info_OS2_2X_Short_Header:
        return ih.height

    case BMP_Info_Header:
        return ih.height

    case BMP_Info_V2_Header:
        return ih.height

    case BMP_Info_V3_Header:
        return ih.height

    case BMP_Info_V4_Header:
        return ih.height

    case BMP_Info_V5_Header:
        return ih.height
    }

    return 0
}

get_bits_per_pixel :: proc(information_header: BMP_Information_Header) -> u16 {
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return ih.bits_per_pixel

    case BMP_Info_OS2_2X_Header:
        return ih.bits_per_pixel

    case BMP_Info_OS2_2X_Short_Header:
        return ih.bits_per_pixel

    case BMP_Info_Header:
        return ih.bits_per_pixel

    case BMP_Info_V2_Header:
        return ih.bits_per_pixel

    case BMP_Info_V3_Header:
        return ih.bits_per_pixel

    case BMP_Info_V4_Header:
        return ih.bits_per_pixel

    case BMP_Info_V5_Header:
        return ih.bits_per_pixel
    }

    return 0
}

get_compression:: proc(
    information_header: BMP_Information_Header,
) -> (compression: u32, error: BMP_Error) {
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return 0, .FieldNotAvailable

    case BMP_Info_OS2_2X_Short_Header:
        return 0, .FieldNotAvailable

    case BMP_Info_OS2_2X_Header:
        return ih.compression, .None

    case BMP_Info_Header:
        return ih.compression, .None

    case BMP_Info_V2_Header:
        return ih.compression, .None

    case BMP_Info_V3_Header:
        return ih.compression, .None

    case BMP_Info_V4_Header:
        return ih.compression, .None

    case BMP_Info_V5_Header:
        return ih.compression, .None
    }

    return 0, .InvalidInformationHeader
}

get_image_size :: proc(information_header: BMP_Information_Header) -> (image_size: u32, error: BMP_Error){
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return 0, .FieldNotAvailable

    case BMP_Info_OS2_2X_Short_Header:
        return 0, .FieldNotAvailable

    case BMP_Info_OS2_2X_Header:
        return ih.image_size, .None

    case BMP_Info_Header:
        return ih.image_size, .None

    case BMP_Info_V2_Header:
        return ih.image_size, .None

    case BMP_Info_V3_Header:
        return ih.image_size, .None

    case BMP_Info_V4_Header:
        return ih.image_size, .None

    case BMP_Info_V5_Header:
        return ih.image_size, .None
    }

    return 0, .InvalidInformationHeader
}

get_information_header_size :: proc(information_header: BMP_Information_Header) -> u32 {
    switch ih in information_header {
    case BMP_Info_Core_Header:
        return ih.size

    case BMP_Info_OS2_2X_Header:
        return ih.size

    case BMP_Info_OS2_2X_Short_Header:
        return ih.size

    case BMP_Info_Header:
        return ih.size

    case BMP_Info_V2_Header:
        return ih.size

    case BMP_Info_V3_Header:
        return ih.size

    case BMP_Info_V4_Header:
        return ih.size

    case BMP_Info_V5_Header:
        return ih.size
    }

    return 0
}

get_red_mask:: proc( information_header: BMP_Information_Header)-> (red_channel_bitmask: u32, error: BMP_Error){

    #partial switch ih in information_header {
    case BMP_Info_V2_Header:
        return ih.red_channel_bitmask, .None

    case BMP_Info_V3_Header:
        return ih.red_channel_bitmask, .None

    case BMP_Info_V4_Header:
        return ih.red_channel_bitmask, .None

    case BMP_Info_V5_Header:
        return ih.red_channel_bitmask, .None
    }

    return 0, .FieldNotAvailable
}

get_green_mask:: proc(information_header: BMP_Information_Header) -> (green_channel_bitmask: u32, error: BMP_Error){
    #partial switch ih in information_header {
    case BMP_Info_V2_Header:
        return ih.green_channel_bitmask, .None

    case BMP_Info_V3_Header:
        return ih.green_channel_bitmask, .None

    case BMP_Info_V4_Header:
        return ih.green_channel_bitmask, .None

    case BMP_Info_V5_Header:
        return ih.green_channel_bitmask, .None
    }

    return 0, .FieldNotAvailable
}

get_blue_mask:: proc(information_header: BMP_Information_Header) -> (blue_channel_bitmask: u32, error: BMP_Error){
    #partial switch ih in information_header {
        case BMP_Info_V2_Header:
            return ih.blue_channel_bitmask, .None

        case BMP_Info_V3_Header:
            return ih.blue_channel_bitmask, .None

        case BMP_Info_V4_Header:
            return ih.blue_channel_bitmask, .None

        case BMP_Info_V5_Header:
            return ih.blue_channel_bitmask, .None
    }

    return 0, .FieldNotAvailable
}

get_alpha_mask:: proc(information_header: BMP_Information_Header)-> (alpha_channel_bitmask: u32, error: BMP_Error){
    #partial switch ih in information_header {
    case BMP_Info_V3_Header:
        return ih.alpha_channel_bitmask, .None

    case BMP_Info_V4_Header:
        return ih.alpha_channel_bitmask, .None

    case BMP_Info_V5_Header:
        return ih.alpha_channel_bitmask, .None
    }

    return 0, .FieldNotAvailable
}