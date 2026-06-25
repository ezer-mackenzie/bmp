package reader

import vmem "core:mem/virtual"

@(deferred_out_by_ptr=auto_reader_destroy)
reader_initialize_scoped:: proc(pathfile: string) -> (r: Reader, error: Generic_Error){
    return reader_initialize(pathfile)
}


@(private)
auto_reader_destroy :: proc(r: ^Reader, error: ^Generic_Error){
    switch e in error {
    case Reader_Error: 
        if e != .None {
            return
        }

    case vmem.Map_File_Error: 
        return
    
    case: 
        return
    }

    reader_destroy(r)
}