package tests

import log "core:log"
import testing "core:testing"

import parser "../../parser"
import reader "../../reader"

// TODO: Build test for 1, 4, 8, 32 bits


@(test)
test_parse_bmp_16_bits:: proc(t: ^testing.T){
    log.info("Initializing test for bmp of 16 bits")

    r, r_error := reader.reader_initialize("assets/test/file16bit.bmp");

    if !testing.expect_value(t, r_error, reader.Reader_Error.None) do return
    defer reader.reader_destroy(&r)

    log.infof("path of file has got: %s", r.filepath)
    log.infof("filename has got: %s", r.filename)

    bmp, bmp_error := parser.parser_bmp(&r);

    if !testing.expect_value(t, bmp_error, parser.BMP_Error.None) do return

    // Values expected
    if !testing.expect_value(t, bmp.version, parser.BMP_Version.Info) do return

    if !testing.expect_value(t, bmp.header.file_size, 4232) do return
    if !testing.expect_value(t, bmp.header.offset_bits, 54) do return

    log.info("BMP reader initialized")
    log.infof("BMP version obtenido: %s", bmp.version)
    log.infof("BMP header obtenido: %#v", bmp.header)
    log.infof("BMP information header obtenido: %#v", bmp.information_header)

    return
}

@(test)
test_parse_bmp_24_bits:: proc(t: ^testing.T){
    log.info("Initializing test for bmp of 124 bits")

    r, r_error := reader.reader_initialize("assets/test/file24bit.bmp");

    if !testing.expect_value(t, r_error, reader.Reader_Error.None) do return
    defer reader.reader_destroy(&r)

    log.infof("path of file has got: %s", r.filepath)
    log.infof("filename has got: %s", r.filename)

    bmp, bmp_error := parser.parser_bmp(&r)

    if !testing.expect_value(t, bmp_error, parser.BMP_Error.None) do return

    // Values expected
    if !testing.expect_value(t, bmp.version, parser.BMP_Version.V5) do return

    if !testing.expect_value(t, bmp.header.file_size, 50334930) do return
    if !testing.expect_value(t, bmp.header.offset_bits, 138) do return

    log.info("BMP reader initialized")
    log.infof("BMP version obtenido: %s", bmp.version)
    log.infof("BMP header obtenido: %#v", bmp.header)
    log.infof("BMP information header obtenido: %#v", bmp.information_header)

    return
}