package parser

import log "core:log"

// the `validate_signature` function checks if the BMP file header contains the correct signature ('BM'). 
// If the signature is invalid, it logs an error and returns an appropriate error code. If the signature is valid, it returns None, indicating no error.
validate_signature :: proc (header: BMP_Header) -> (error: BMP_Error) {
    if header.signature[0] != 'B' || header.signature[1] != 'M' {
        log.error("El archivo no tiene una firma BMP ('BM') válida.");
        return .InvalidSignature
    }

    return .None
}


// the `validate_compression` function checks if the BMP file uses a supported compression type (only 0 - BI_RGB is supported in this basic reader)
validate_compression :: proc (compression: u32) -> (error: BMP_Error) {
    if compression != 0 {
        log.warnf("El BMP usa compresión tipo %d. Este lector básico espera 0 (sin compresión).", compression)
        return .UnsupportedCompression
    }
    
    return .None
}

// the `validate_offset_bits` function checks if the header of BMP has a valid offset bits
validate_offset_bits :: proc (header: BMP_Header, data_length: int) -> (error: BMP_Error) {
    if header.offset_bits < 14 {
        log.errorf("El offset a los datos de píxeles (%d bytes) es menor que el tamaño mínimo del encabezado (14 bytes).", header.offset_bits)
        return .InvalidPixelOffset
    }


    if int(header.offset_bits) >= data_length {
        log.errorf("El offset a los datos de píxeles (%d bytes) excede el tamaño total de los datos disponibles (%d bytes).", header.offset_bits, data_length)
        return .InvalidPixelOffset
    }

    return .None
}

validate_planes :: proc (planes: u16) -> (error: BMP_Error) {
    if planes != 1 {
        log.errorf("El número de planos debe ser 1, pero se encontró %d.", planes)
        return .InvalidHeader
    }

    log.info("Info: BMP has a valid planes")
    return .None
}

// the `validate_dimensions` function checks if width and height are higher than 0 if not return error
validate_dimensions :: proc (width: i32, height: i32) -> (error: BMP_Error) {
    if width <= 0 || height == 0 {
        log.errorf("Las dimensiones de la imagen no son válidas. Ancho: %d, Alto: %d.", width, height)
        return .InvalidDimensions
    }

    log.info("BMP has a valid dimensions")
    return .None
}

// the `validate_bits_per_pixel` function checks if the bits per pixel value in the BMP information header is supported.
// This reader supports indexed BMP palettes for 1, 2, 4, and 8 bits, plus direct color formats for 16, 24, and 32 bits.
validate_bits_per_pixel :: proc(bits_per_pixel: u16) -> (error: BMP_Error) {
    switch bits_per_pixel {
    case 1, 2, 4, 8, 16, 24, 32:
            log.infof("BMP has a valid bits per pixel: %d", bits_per_pixel)
            return .None

    case: 
            log.errorf("Unsupported bits per pixel: %d", bits_per_pixel)
            return .UnsupportedBitDepth
    }
}

// the `validate_header_image_size` function checks if the declared image size in the BMP information header matches the actual size of the pixel data available. 
// If the declared size is non-zero and does not match the actual size, it logs a warning and returns an error. Otherwise, it returns None, indicating that the image size is valid or
validate_header_image_size :: proc (offset_bits: u32, image_size: u32, data_length: int) -> (error: BMP_Error) {
    expected_pixel_data_size := int(image_size)
    actual_pixel_data_size := data_length - int(offset_bits)

    if expected_pixel_data_size != 0 && expected_pixel_data_size > actual_pixel_data_size {
        log.warnf("El tamaño de los datos de píxeles declarado (%d bytes) no coincide con el tamaño real disponible (%d bytes).", expected_pixel_data_size, actual_pixel_data_size)
        return .InvalidImageSize
    }

    return .None
}