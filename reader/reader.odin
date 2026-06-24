package reader

import log "core:log"
import vmem "core:mem/virtual"


// the `reader_init` function initializes a new Reader with the given data.
reader_initialize :: proc (path_file: string) -> (reader: Reader, error: union{Reader_Error, vmem.Map_File_Error}) {
    log.infof("Initializing BMP reader with file: %s", path_file)

    // Attempt to map the file into memory and create a Reader struct with the mapped data. If mapping fails, return an error.
    data := reader_handle_source(path_file) or_return

    return Reader{
        data = data,
        position = 0,
    }, Reader_Error.None
}


// the `reader_handle_source` function takes a file path as input and attempts to map the file into memory. 
// It returns the mapped data as a byte slice and an error code (0 for success, 1 for failure). 
// If the file cannot be mapped, it prints an error message to the console.
reader_handle_source:: proc (path_file: string) -> (data: []byte, error: vmem.Map_File_Error) {
    log.infof("Mapping file: %s", path_file)
    
    return vmem.map_file_from_path(path_file, {.Read})
}


// the `reader_peek` function returns the byte at the current position without advancing the position. If the position is out of bounds, it returns 0.
reader_peek :: proc (r: ^Reader) -> (byte:u8, error: Reader_Error) {
    data:= r.data

    // Check if we've reached the end of the data before trying to consume a byte
    eof := reader_check_bounds(len(data), r.position) or_return

    return data[r.position], Reader_Error.None
}


// the `reader_consume` function returns the byte at the current position and advances the position by one. If the position is out of bounds, it returns 0.
reader_consume :: proc (r: ^Reader) -> (byte: u8, error: Reader_Error) {
    byte = reader_peek(r) or_return
    r.position += 1

    return byte, Reader_Error.None
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
    r.position = 0

    log.info("BMP reader destroyed")
}