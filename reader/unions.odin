package reader

import vmem "core:mem/virtual"

Generic_Error:: union {
    Reader_Error,
    vmem.Map_File_Error
}