module IO

    using Logging: debug, info, error
    using JSON: parsefile, print

    export create_dir, find_files, write_json, save_data, load_data

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

    """
    `write_json(filename::AbstractString, dict::Dict)`

    Write a dictionary to a json file
    """
    function write_json(filename::AbstractString, dict::Dict)

        json_file = open(filename, "w")
        print(json_file, dict)
        close(json_file)
        return 0
    end

    # save and load uses .json for portabilty across languages
    # could not get hdf5 to work on some variables I was using, should have function for formart .h5
    """
    `save_data(filename::AbstractString, variable)`

    Save a variable to file

    ### Arguments
    - `filename::AbstractString`
    - `variable`
    """
    function save_data(filename::AbstractString, variable)
        dict = Dict("v" => variable)
        write_json(filename, dict)
        return 0
    end

    """
    `load_data(filename::AbstractString)`

    Load a variable from a file

    ### Arguments
    - `filename::AbstractString`
    """
    function load_data(filename::AbstractString)
        d = parsefile(filename)
        return d["v"]
    end

end # module