package parser

// Represents a color palette in a BMP file, used for indexed color images (8 bits per pixel or less).
Palette :: struct #packed {
    blue: u8,
    green: u8,
    red: u8,
    reserved: u8,
};

// Represents the header of a BMP file, containing metadata about the file itself. 
BMP_Header :: struct #packed {
    signature: [2]u8,
    file_size: u32,
    reserved_one: u16,
    reserved_two: u16,
    offset_bits: u32,
}

// Represents a color in the CIE XYZ color space, where each component (X, Y, Z) is a 32-bit signed integer. This structure is used in the BITMAPV5HEADER for defining color space endpoints.
CIEXYZ :: struct #packed {
    x: i32,
    y: i32,
    z: i32,
}

// Represents a triple of CIEXYZ colors, used in the BITMAPV5HEADER for defining color space endpoints for the red, green, and blue channels. Each channel has its own CIEXYZ structure, which defines the color space endpoints for that channel.
CIEXYZTRIPLE :: struct #packed {
    red: CIEXYZ,
    green: CIEXYZ,
    blue: CIEXYZ,
}


// Represents the information header of a BMP file in the older BITMAPCOREHEADER format, which uses 16-bit integers for width and height.
// This format is less common and has limitations (e.g., maximum dimensions of 65535x65535), but it's still supported by some BMP files.
// The BITMAPCOREHEADER is 12 bytes long and is used in older BMP formats (e.g., OS/2 1.x). It has a different structure compared to the more common BITMAPINFOHEADER.
// The BITMAPCOREHEADER uses 16-bit integers for width and height, which limits the maximum dimensions of the image to 65535x65535 pixels. It also does not support compression or color profiles, and it is less commonly used in modern BMP files.
BMP_Info_Core_Header :: struct #packed {
    size: u32,
    width: i16,
    height: i16,
    planes: u16,
    bits_per_pixel: u16,
};


BMP_Info_OS2_2X_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
    compression: u32,
    image_size: u32,
    x_pixels_per_meter: i32,
    y_pixels_per_meter: i32,
    colors_used: u32,
    important_colors: u32,
    units: u16,
    reserved: u16,
    recording: u16,
    rendering: u16,
    size1: u32,
    size2: u32,
    color_encoding: u32,
    identifier: u32,
}


BMP_Info_OS2_2X_Short_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
}

BMP_Info_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
    compression: u32,
    image_size: u32,
    x_pixels_per_meter: i32,
    y_pixels_per_meter: i32,
    colors_used: u32,
    important_colors: u32,
}


BMP_Info_V2_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
    compression: u32,
    image_size: u32,
    x_pixels_per_meter: i32,
    y_pixels_per_meter: i32,
    colors_used: u32,
    important_colors: u32,
    red_channel_bitmask: u32,
    green_channel_bitmask: u32,
    blue_channel_bitmask: u32,
}


BMP_Info_V3_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
    compression: u32,
    image_size: u32,
    x_pixels_per_meter: i32,
    y_pixels_per_meter: i32,
    colors_used: u32,
    important_colors: u32,
    red_channel_bitmask: u32,
    green_channel_bitmask: u32,
    blue_channel_bitmask: u32,
    alpha_channel_bitmask: u32,
}

BMP_Info_V4_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
    compression: u32,
    image_size: u32,
    x_pixels_per_meter: i32,
    y_pixels_per_meter: i32,
    colors_used: u32,
    important_colors: u32,
    red_channel_bitmask: u32,
    green_channel_bitmask: u32,
    blue_channel_bitmask: u32,
    alpha_channel_bitmask: u32,
    color_space_type: u32,
    color_space_endpoints: CIEXYZTRIPLE,
    gamma_for_red_channel: u32,
    gamma_for_green_channel: u32,
    gamma_for_blue_channel: u32,
}

BMP_Info_V5_Header :: struct #packed {
    size: u32,
    width: i32,
    height: i32,
    planes: u16,
    bits_per_pixel: u16,
    compression: u32,
    image_size: u32,
    x_pixels_per_meter: i32,
    y_pixels_per_meter: i32,
    colors_used: u32,
    important_colors: u32,
    red_channel_bitmask: u32,
    green_channel_bitmask: u32,
    blue_channel_bitmask: u32,
    alpha_channel_bitmask: u32,
    color_space_type: u32,
    color_space_endpoints: CIEXYZTRIPLE,
    gamma_for_red_channel: u32,
    gamma_for_green_channel: u32,
    gamma_for_blue_channel: u32,
    intent: u32,
    icc_profile_data: u32,
    icc_profile_size: u32,
    reserved: u32,
};

// Represents a BMP file, containing the header, information header, palette, and pixel data.
BMP :: struct {
    header: BMP_Header,
    information_header: BMP_Information_Header,
    version: BMP_Version,
    palette: []Palette,
    pixel_data: []u8,
};

