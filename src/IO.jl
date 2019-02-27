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
    `save_data(filename::AbstractString, variable; format::AbstractString=".json", dir::AbstractString="")`
    `save_data(args::AbstractString...; format::AbstractString=".json", dir::AbstractString="")`

    Save a variable to file

    ### Usage
    save_data("a", 1, dir="data")
    save_data("a", 1, "b", 2, dir="data")

    ### Arguments
    - `filename::AbstractString`
    - `variable` : variable to save in file

    ### Optional Arguments
    - `format::AbstractString=".json"` : format of file (currently not much use, always writes to .json)
    - `dir::AbstractString=""` : separate directory argument, if not given in filename

    """
    function save_data(filename::AbstractString, variable; format::AbstractString=".json", dir::AbstractString="")

        fn = filename

        # find if file extension given, if not then add
        inds = findlast(".", fn)
        if length(collect(inds)) == 0 fn = string(filename, format) end

        # add directory if given as keyword arg
        if dir != "" fn = joinpath(dir, fn) end

        dict = Dict("v" => variable)
        write_json(fn, dict)
        return 0
    end
    function save_data(args::AbstractString...; format::AbstractString=".json", dir::AbstractString="")

        if iseven(length(args)) != true
            error("Need name and variable pairs")
            return 1
        end

        for n in 1:Int(length(args)/2.0)
            @show args[n]
            @show args[n+1]
            save_data(args[(2*n)-1], args[(2*n)]; format=format, dir=dir)
        end
    end

    """
    `load_data(filename::AbstractString)`
    `load_data(args::AbstractString...; dir::AbstractString="")`

    Load a variable from a file

    ### Usage
    a = load_data("a")
    a, b = load_data("a", "b"; dir="data")

    ### Arguments
    - `filename::AbstractString`

    ### Optional Arguments
    - `dir::AbstractString=""` : separate directory argument, if not given in filename
    """
    function load_data(filename::AbstractString; dir::AbstractString="")

        fn = filename
        if dir != "" fn = joinpath(dir, fn) end
        d = parsefile(fn)
        return d["v"]
    end
    function load_data(args::AbstractString...; dir::AbstractString="")

        vars = Array{Any}(length(args))
        for i in 1:length(vars)
            vars[i] = load_data(args[i]; dir=dir)
        end
        return vars
    end

end # module