module IO

export createdir

    """
    `createdir(path::String)`

    Create a directory of given path.
    Provide warning if it already exists.
    """
    function createdir(path::String)

        if isdir(path) == false
            mkpath(path)
            info("Made directory:\n", path)
        else isdir(path) == true
            warn("Directory already exists, will overwrite any existing files\ndir: ", path)
        end
        return path
    end


end # module