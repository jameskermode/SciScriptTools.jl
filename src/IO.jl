module IO

    using Logging: debug, info, error

    export create_dir, find_files

    """
    `create_dir(path::String)`

    Create a directory of given path.
    Provide warning if it already exists.
    """
    function create_dir(path::String)

        if isdir(path) == false
            mkpath(path)
            info("Made directory:\n", path)
        else isdir(path) == true
            warn("Directory already exists, will overwrite any existing files\ndir: ", path)
        end
        return path
    end

    """
    `find_files(prefix::AbstractString=""; suffix::AbstractString="", path::AbstractString="")`

    Find files of a given prefix and/or suffix.

    ### Arguments
    `prefix::AbstractString=""` : start of the filename

    ### Optional Arguments
    `suffix::AbstractString=""` : end of the filename, eg file format
    """
    function find_files(prefix::AbstractString=""; suffix::AbstractString="")

        with_path = false # flag for whether prefix came with a path or not
        path = dirname(prefix)
        if path != "" with_path = true
        elseif path == "" path = pwd() end
        prefix = basename(prefix)
        list = readdir(path)
        inds_b = nothing

        if prefix != "" && suffix != ""
            inds_b = startswith.(list, prefix) .* endswith.(list, suffix)
        elseif prefix != ""
            inds_b = startswith.(list, prefix)
        elseif suffix != ""
            inds_b = endswith.(list, suffix)
        else error("Need to provide at least a prefix or suffix") end

        filenames = list[inds_b]

        # joinpath() will actually ignore if path == "", keep if for logically reasoning and large lists
        if with_path == true
            [filenames[i] = joinpath(path, filenames[i]) for i in 1:length(filenames)]
        end

        return filenames
    end

end # module