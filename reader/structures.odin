package reader

// Represents a reader for BMP files, containing the file data and the current position in the data.
Reader:: struct {
    data: []byte,
    position: int,
}

