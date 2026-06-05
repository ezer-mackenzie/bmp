package main

import log "core:log"

import reader "reader";
import bmp "bmp";

// The `main` procedure serves for test library functions and debugging.
// It initializes a console logger, sets it in the context, and attempts to read and parse a BMP file located at "assets/UlrichS.bmp". 
// It logs the initialization and the first byte position of the reader for debugging purposes. Finally, it returns from the procedure.
main :: proc (){
    // Create a console logger for debugging purposes
    // Set the logger in the context so that it can be used throughout the application
    // Set the log level to Debug to see detailed information during development
    logger := log.create_console_logger()
    context.logger = logger
    context.logger.lowest_level = log.Level.Debug

    // Clean up the logger when the program exits
    defer log.destroy_console_logger(logger)

    reader, reader_error := reader.reader_initialize("assets/UlrichS.bmp");
    
    bmp, bmp_error := bmp.bmp_parser(&reader);

    log.info("BMP reader initialized");
    log.info("First byte: %d", reader.position);

    return;
}


    /* for i in 0..=len(r.data){
        log.info("Byte %d: %d || Position %d", i, reader.bmp_reader_peek(&r), r.position);
        reader.bmp_reader_consume(&r);

        time.sleep(1 * time.Second);
    } */
