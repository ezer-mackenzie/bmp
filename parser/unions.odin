package parser

// Unions of all versions of BMP
BMP_Information_Header :: union {
    BMP_Info_Core_Header,
    BMP_Info_OS2_2X_Header,
    BMP_Info_OS2_2X_Short_Header,
    BMP_Info_Header,
    BMP_Info_V2_Header,
    BMP_Info_V3_Header,
    BMP_Info_V4_Header,
    BMP_Info_V5_Header,
}