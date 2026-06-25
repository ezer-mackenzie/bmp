package reader

// Represents a reader for BMP files, containing the file data and the current position in the data.
Reader:: struct {
    filepath: string,
    filename: string,
    data: []byte,
}
