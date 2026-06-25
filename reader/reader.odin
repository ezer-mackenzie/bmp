package reader

import log "core:log"
import vmem "core:mem/virtual"


// the `reader_init` function initializes a new Reader with the given data.
reader_initialize :: proc (path: string) -> (reader: Reader, error: Generic_Error) {
    _, pathname, filename := validate_bmp_extension(path) or_return

    log.infof("Initializing BMP reader: %s", path)

    data, d_error := reader_handle_source(path)

    if d_error != .None {
        return {}, d_error
    }

    return {pathname, filename, data}, Reader_Error.None
}


// the `reader_handle_source` function takes a file path as input and attempts to map the file into memory. 
// It returns the mapped data as a byte slice and an error code (0 for success, 1 for failure). 
// If the file cannot be mapped, it prints an error message to the console.
reader_handle_source:: proc (path: string) -> (data: []byte, error: vmem.Map_File_Error) {
    log.infof("Mapping file: %s", path)
    
    return vmem.map_file_from_path(path, {.Read})
}

// the `reader_eof` function returns true if the reader has reached the end of the file, false otherwise.
reader_check_bounds:: proc (data_length: int, position: int) -> (success: bool, error: Reader_Error) {
    if (position < 0 || position >= data_length) do return false, Reader_Error.Byte_Out_Of_Bounds
    
    return true, Reader_Error.None
}

// the `reader_destroy` function unmaps the file data and resets the reader's state. It also logs the destruction process.
reader_destroy :: proc (r: ^Reader) {
    if r == nil || r.data == nil do return

    log.info("Destroying BMP reader")

    vmem.unmap_file(r.data)
    r.data = nil

    log.info("BMP reader destroyed")
}