package bmp

// This file defines the BMP_Error enum, which represents various error conditions that can occur while parsing a BMP file.
BMP_Error :: enum {
    None,
    InvalidSignature,
    InvalidHeader,
    InvalidPixelOffset,
    InvalidDimensions,
    InvalidImageSize,
    InvalidInformationHeader,
    UnsupportedCompression,
    UnsupportedBitDepth,
    UnsupportedVersion,
    OutOfBounds,
    FieldNotAvailable,
}