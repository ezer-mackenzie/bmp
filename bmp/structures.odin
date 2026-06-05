package bmp;

// Represents a color in RGBA format, where each component (red, green, blue, alpha) is an 8-bit unsigned integer.
Color :: struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
}

// Represents the header of a BMP file, containing metadata about the file itself.
Header :: struct #packed {
    signature: [2]u8,
    file_size: u32,
    reserved_one: u16,
    reserved_two: u16,
    offset_bits: u32,
}

// Represents the information header of a BMP file, containing metadata about the image.
Information_Header :: struct #packed {
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
};

// Represents a color palette in a BMP file, used for indexed color images (8 bits per pixel or less).
Palette :: struct #packed {
    blue: u8,
    green: u8,
    red: u8,
    reserved: u8,
};

// Represents a BMP file, containing the header, information header, palette, and pixel data.
BMP :: struct {
    header: Header,
    information_header: Information_Header,
    palette: []Palette,
    pixel_data: []u8,
};
