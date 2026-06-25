package report

import parser "../parser"


Report:: struct {
    pathfile: string,
    filename: string,
    metadata: Metadata
}


Metadata:: struct {
    file_version: parser.BMP_Version,
    file_header: parser.BMP_Header,
    file_information_header: parser.BMP_Information_Header,
    messages: []string,
}