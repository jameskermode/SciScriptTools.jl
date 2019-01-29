module IO

    using Logging: debug, info, error

    export create_dir, find_files, remove_format

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
    Note: Will not handle entire filenames, only partial names.

    ### Arguments
    `prefix::AbstractString=""` : start of the filename

    ### Optional Arguments
    `suffix::AbstractString=""` : end of the filename, eg file format
    """
    function find_files(prefix::AbstractString=""; suffix::AbstractString="")

        with_path = false # flag for whether prefix came with a path or not
        path = dirname(prefix)
        if path != "" with_path = true end
        elseif path == "" path = pwd() end
        prefix = basename(prefix)
        list = readdir(path)
        m_str = ""

        if prefix != "" && suffix != ""
            m_str = string(prefix, "(.+)", suffix)
        elseif prefix != ""
            m_str = string(prefix, "(.+)")
        elseif suffix != ""
            m_str = string("(.+)", suffix)
        else error("Need to provide at least a prefix or suffix") end

        info(@sprintf("Looking for files with form: %s ", m_str))
        filenames = Array{String}([])
        for i in 1:length(list)
            if match(Regex(m_str), list[i]) != nothing
                push!(filenames, list[i])
            end
        end

        # joinpath() will actually ignore if path == "", keep if for logically reasoning and large lists
        if with_path == true
            [filenames[i] = joinpath(path, filenames[i]) for i in 1:length(filenames)]
        end

        return filenames
    end

# remove file extension and dot (-1)
    """
    `remove_format(filename::AbstractString)`

    Remove file extension and dot from filename.
    """
    function remove_format(filename::AbstractString)
        filename_inds = 1:(findlast(".", filename)-1)[1]
        return filename[filename_inds]
    end

end # module