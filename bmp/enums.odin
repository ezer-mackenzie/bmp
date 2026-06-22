package bmp

/*
BMP version enumeration
Size (bytes) 	Header name 	OS support 	Features 	Written by
12 	BITMAPCOREHEADER / OS21XBITMAPHEADER | Windows 2.0 or later OS/2 1.x[3] 		
64 	OS22XBITMAPHEADER 	OS/2 BITMAPCOREHEADER2 	Adds halftoning. Adds RLE and Huffman 1D compression. 	
16 	OS22XBITMAPHEADER 	This variant of the previous header contains only the first 16 bytes and the remaining bytes are assumed to be zero values.[3] An example of such a case is the graphic pal8os2v2-16.bmp[9] of the BMP Suite.[10]		
40 	BITMAPINFOHEADER 	Windows NT, 3.1x or later[2] 	Extends bitmap width and height to 4 bytes. Adds 16 bpp and 32 bpp formats. Adds RLE compression. 	
52 	BITMAPV2INFOHEADER 	Undocumented 	Adds RGB bit masks. 	Microsoft
56 	BITMAPV3INFOHEADER 	Not officially documented, but this documentation was posted on Adobe's forums, by an employee of Adobe with a statement that the standard was at one point in the past included in official MS documentation[11] 	Adds alpha channel bit mask. 	Microsoft
108 	BITMAPV4HEADER 	Windows NT 4.0, 95 or later 	Adds color space type and gamma correction 	
124 	BITMAPV5HEADER 	Windows NT 5.0, 98 or later 	Adds ICC color profiles 	GIMP
*/
BMP_Version :: enum {
    Invalid = 0,

    Core = 12,

    OS2_2X = 64,
    OS2_2X_Short = 16,
    
    Info = 40,
    V2   = 52,
    V3   = 56,
    V4   = 108,
    V5   = 124,
}