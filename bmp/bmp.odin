package bmp

import log "core:log"
import reader "../reader"


bmp_initialize :: proc (r: ^reader.Reader) -> (bmp: BMP, error: BMP_Error) {
    bmp = bmp_parser(r) or_return

    return bmp, BMP_Error.None
}

bmp_parser :: proc (r: ^reader.Reader) -> (bmp: BMP, error: BMP_Error) {
    log.info("Initializing BMP reader with data of length %d bytes", len(r.data));

    // Read the file header and information header from the BMP file
    header := bmp_parse_header(r) or_return

    // Validate the header and information header, and if valid, create a BMP struct
    information_header := bmp_parse_information_header(r) or_return

    // validate the declared image size against the actual data length, if there's a mismatch, return an error
    bmp_validate_header_image_size(header, information_header, len(r.data)) or_return

    // validate the offset to pixel data, if it's invalid, return an error
    bmp_validate_offset_bits(header, len(r.data)) or_return

    pixel_data := r.data[header.offset_bits:]

    palette_size := int(header.offset_bits) - (14 + int(information_header.size))

    log.info("Calculated palette size: %d bytes", palette_size)

    bmp = BMP{
        header,
        information_header,
        {}, // TODO: implement palette parsing for 8-bit indexed BMPs
        pixel_data,
    };

    log.info("Offset to pixel data: %d bytes is equals to %d", header.offset_bits, len(r.data) - int(header.offset_bits));
    log.info("Offset express validation value: %d", len(r.data) - int(header.offset_bits));
    log.info("File size length: %d bytes equals to %d", header.file_size, len(r.data));
    log.info("BMP initialized successfully.");

    return bmp, BMP_Error.None;
}

// the `bmp_parse_header` function reads the BMP file header from the provided reader and validates it. 
// It checks if the data length is sufficient to contain the header, then extracts the header
// and validates the BMP signature. If the signature is valid, it returns the header; otherwise, it returns an appropriate error.
bmp_parse_header :: proc (r: ^reader.Reader) -> (header: Header, error: BMP_Error) {
    log.info("Reading BMP file header...");

    if len(r.data) < 14 do return {}, BMP_Error.InvalidHeader;

    header = (transmute(^Header)(&r.data[0]))^;

    // validate the BMP signature in the header, if it's not valid, return an error
    bmp_validate_signature(header) or_return

    log.info("File header: %d", header);

    return header, BMP_Error.None;
}

// the `bmp_parse_information_header` function reads the BMP information header from the provided reader and validates it. 
// It checks if the data length is sufficient to contain the header, then extracts the information header and checks for unsupported compression types. 
// If everything is valid, it returns the information header; otherwise, it returns an appropriate error.
bmp_parse_information_header :: proc (r: ^reader.Reader) -> (information_header: Information_Header, error: BMP_Error) {
    log.info("Reading BMP information header...")

    if len(r.data) < 18 {
        return {}, BMP_Error.InvalidHeader
    }

    header_size := (transmute(^u32)(&r.data[14]))^
    
    switch header_size {
    case 12, 40, 52, 56, 108, 124:
        // válido
        information_header = (transmute(^Information_Header)(&r.data[14]))^

        // validate the compression type of the BMP file, if it's not supported, return an error
        bmp_validate_compression(information_header) or_return

        // validate the bits per pixel of the BMP file, if it's not supported, return an error
        bmp_validate_bits_per_pixel(information_header) or_return

        // validate the number of planes of the BMP file, if it's not supported, return an error
        bmp_validate_planes(information_header) or_return

        // validate the dimensions of the BMP file, if they're not valid, return an error
        bmp_validate_dimensions(information_header) or_return

        log.info("Information header: %d", information_header)

        return information_header, BMP_Error.None

    case:
        log.error(
            "Unsupported DIB header size: %d",
            header_size,
        )
        return {}, BMP_Error.InvalidHeader
    }
}

// the `bmp_validate_signature` function checks if the BMP file header contains the correct signature ('BM'). If the signature is invalid, it logs an error and returns an appropriate error code. If the signature is valid, it returns None, indicating no error.
bmp_validate_signature :: proc (header: Header) -> (error: BMP_Error) {
    if header.signature[0] != 'B' || header.signature[1] != 'M' {
        log.error("Error: El archivo no tiene una firma BMP ('BM') válida.");
        return BMP_Error.InvalidSignature
    }

    return BMP_Error.None
}

// the `bmp_validate_compression` function checks if the BMP file uses a supported compression type (only 0 - BI_RGB is supported in this basic reader)
bmp_validate_compression :: proc (information_header: Information_Header) -> (error: BMP_Error) {
    if information_header.compression != 0 {
        log.warn("Advertencia: El BMP usa compresión tipo %d. Este lector básico espera 0 (sin compresión).", information_header.compression)
        return BMP_Error.UnsupportedCompression
    }
    
    return BMP_Error.None
}

// the `bmp_validate_header_image_size` function checks if the declared image size in the BMP information header matches the actual size of the pixel data available. 
// If the declared size is non-zero and does not match the actual size, it logs a warning and returns an error. Otherwise, it returns None, indicating that the image size is valid or
bmp_validate_header_image_size :: proc (header: Header, information_header: Information_Header, data_length: int) -> (error: BMP_Error) {
    expected_pixel_data_size := int(information_header.image_size)
    actual_pixel_data_size := data_length - int(header.offset_bits)

    if expected_pixel_data_size != 0 && expected_pixel_data_size > actual_pixel_data_size {
        log.warn("Advertencia: El tamaño de los datos de píxeles declarado (%d bytes) no coincide con el tamaño real disponible (%d bytes).", expected_pixel_data_size, actual_pixel_data_size)
        return BMP_Error.InvalidImageSize
    }

    return BMP_Error.None
}

bmp_validate_offset_bits :: proc (header: Header, data_length: int) -> (error: BMP_Error) {
    if header.offset_bits < 14 {
        log.error("Error: El offset a los datos de píxeles (%d bytes) es menor que el tamaño mínimo del encabezado (14 bytes).", header.offset_bits)
        return BMP_Error.InvalidPixelOffset
    }


    if int(header.offset_bits) >= data_length {
        log.error("Error: El offset a los datos de píxeles (%d bytes) excede el tamaño total de los datos disponibles (%d bytes).", header.offset_bits, data_length)
        return BMP_Error.InvalidPixelOffset
    }

    return BMP_Error.None


}

bmp_validate_planes :: proc (information_header: Information_Header) -> (error: BMP_Error) {
    if information_header.planes != 1 {
        log.error("Error: El número de planos debe ser 1, pero se encontró %d.", information_header.planes)
        return BMP_Error.InvalidHeader
    }

    return BMP_Error.None
}

bmp_validate_dimensions :: proc (information_header: Information_Header) -> (error: BMP_Error) {
    if information_header.width <= 0 || information_header.height == 0 {
        log.error("Error: Las dimensiones de la imagen no son válidas. Ancho: %d, Alto: %d.", information_header.width, information_header.height)
        return BMP_Error.InvalidDimensions
    }

    return BMP_Error.None
}

// the `bmp_validate_bits_per_pixel` function checks if the bits per pixel value in the BMP information header is supported 
// (only 24 and 32 bits are supported in this basic reader).
bmp_validate_bits_per_pixel :: proc(
    information_header: Information_Header,
) -> (error: BMP_Error) {

    switch information_header.bits_per_pixel {
        case 8, 16, 24, 32:
            return BMP_Error.None

        case: 
            log.error(
                "Unsupported bits per pixel: %d",
                information_header.bits_per_pixel,
            )

            return BMP_Error.UnsupportedBitDepth
    }
}

// the `bmp_get_pixel` function retrieves the color of a specific pixel at coordinates (x, y) from the BMP image. 
// It first checks if the coordinates are within the bounds of the image. 
// Then, it calculates the correct index in the pixel data array based on the image's width, height, bits per pixel and the BMP format's row padding.
bmp_get_pixel :: proc(bmp: ^BMP, x, y: int) -> (color: Color, error: BMP_Error) {
    w := int(bmp.information_header.width)
    h := int(bmp.information_header.height)

    // Validar que las coordenadas estén dentro de los límites de la imagen
    if x < 0 || x >= w || y < 0 || y >= h {
        return {}, BMP_Error.OutOfBounds
    }

    // El formato BMP por defecto guarda las filas invertidas verticalmente (de abajo hacia arriba).
    // Si 'height' es positivo, invertimos 'y' para que (0,0) sea la esquina superior izquierda de forma estándar.
    target_y := y
    if bmp.information_header.height > 0 {
        target_y = (h - 1) - y
    }

    switch bmp.information_header.bits_per_pixel {
        case 24:
            // En 24 bits (RGB), cada fila debe alinearse a múltiplos de 4 bytes (Padding)
            row_stride := bmp_calculate_stride(w, 24)
            index := (target_y * row_stride) + (x * 3)

            if index + 2 >= len(bmp.pixel_data) {
                return {}, BMP_Error.OutOfBounds // TODO: replace for error handling with BMP_Error.OutOfBounds
            }

            // El orden en memoria de un BMP de 24 bits es BGR
            b := bmp.pixel_data[index + 0]
            g := bmp.pixel_data[index + 1]
            r := bmp.pixel_data[index + 2]
            return Color{r, g, b, 255}, BMP_Error.None // 255 significa totalmente opaco
            
        case 32:
            // En 32 bits (RGBA) no hay padding. Cada fila mide exactamente: ancho * 4 bytes
            row_stride := bmp_calculate_stride(w, 32)
            index := (target_y * row_stride) + (x * 4)

            if index + 3 >= len(bmp.pixel_data) {
                return {}, BMP_Error.OutOfBounds // TODO: replace for error handling with BMP_Error.OutOfBounds
            }

            // El orden en memoria de un BMP de 32 bits suele ser BGRA
            b := bmp.pixel_data[index + 0]
            g := bmp.pixel_data[index + 1]
            r := bmp.pixel_data[index + 2]
            a := bmp.pixel_data[index + 3]
            return Color{r, g, b, a}, BMP_Error.None // TODO: replace for error handling with BMP_Error.None

        case:
            // Formato de bits no soportado por este extractor (ej. 8 bits indexado)
            return {}, BMP_Error.UnsupportedBitDepth
    }
}

// the `bmp_calculate_stride` function calculates the stride (the number of bytes in a row of pixel data, including any padding) for a given image width and bits per pixel. 
// For 24 bits per pixel, it ensures that the stride is a multiple of 4 bytes by adding padding if necessary. For other bit depths, it simply calculates the stride based on the width and bytes per pixel.
bmp_calculate_stride :: proc(width: int, bits_per_pixel: int) -> (stride: int) {
    bytes_per_pixel := bits_per_pixel / 8

    if bits_per_pixel == 24 {
        return ((width * bytes_per_pixel) + 3) & ~int(3)
    }

    return width * bytes_per_pixel
}
