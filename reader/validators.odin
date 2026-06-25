package reader

import strings "core:strings"
import filepath "core:path/filepath"

validate_bmp_extension:: proc(
    path: string
) -> (dirname: string, pathname: string, filename: string, error: Reader_Error){
    file_extension := filepath.ext(path)
    file_extension_lower := strings.to_lower(file_extension, context.temp_allocator)

    if file_extension_lower != ".bmp" {
        return "", "", "", .Invalid_Format
    }

    dirname = filepath.dir(path)
    pathname = filepath.base(path)
    filename = filepath.stem(path)

    return dirname, pathname, filename, .None
}