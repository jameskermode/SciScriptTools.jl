module Conversion

    export dict_convert_keys, dict_to_arrays, pair_to_list

    """
    `dict_convert_keys(dict::Dict)`

    'Converts' dictionary keys of strings/symbols to keys of symbols/strings.
    If dictionary contains mixed strings and symbols it converts all the keys to symbols.
    Returns new dictionary.
    """
    function dict_convert_keys(dict::Dict)

        dk = collect(keys(dict))
        t = nothing
        if typeof(dk) == Array{Symbol,1} t = "t_symbol" end

        dict_c = nothing
        if t == "t_symbol" dict_c = Dict{String, Any}()
        else dict_c = Dict{Symbol, Any}() end

        for i in 1:length(dk)
            if t == "t_symbol" dict_c[String(dk[i])] = dict[dk[i]] # convert symbols into strings
            else dict_c[Symbol(dk[i])] = dict[dk[i]] end # convert string and mixed keys into symbols
        end

        return dict_c 
    end

    """
    `dict_to_arrays(dict::Dict; key_order::Array{Symbol} = Array{Symbol}([]))`

    Convert dictionary into two arrays, returns array of arrays and array of keys in the same order.
    Can extract and/or order certain arrays using `key_order`.

    ### Arguments
    - `dict::Dict`

    ### Optional Arguments
    - `key_order::Array{Symbol}` : list of keys to extract from dictionary, arrays will return in this order

    ### Returns
    - `arrays` : array object of arrays
    - `key_order` : list of keys in the order of arrays object
    """
    function dict_to_arrays(dict::Dict; key_order::Array{Symbol} = Array{Symbol}([]))

        # get all keys if no keys given
        if length(key_order) == 0 key_order = Array{Symbol}(collect(keys(dict))) end

        # generate and assign dictionary arrays to an array in order of the keys
        arrays = Array{Any, 1}(length(key_order))
        for i in 1:length(key_order)
            arrays[i] = dict[key_order[i]]
        end

        # try apply target type to all arrays, if it fails, variable arrays will be of type Any
        target_type = typeof(arrays[1][1])
        try arrays = Array{target_type}.(arrays)
        catch debug("Automatic conversion of types failed to apply to all, no singular type") end

        # returning `key_order` is redundent when optional argument for `key_order` is provided
        # rather than just return `arrays`, keep the consistency of always returning the same number of objects
        return arrays, key_order
    end

    """
    `pair_to_list{T<:Any}(pairs::Array{Tuple{T, T}}; split = false)`

    Takes array of tuples and returns flatten array.

    ### Arugments
    - `pairs::Array{Tuple}` : tuple array of any type 
    - `split = false` : `false` flattens tuple by tuple,
                        `true` returns with first index of all tuples than second index of all tuples
    """
    # this can be generalised to Tuples of any length rather than just pairs, could turn into flat array or matrix
    pair_to_list(pair::Tuple) = [pair[1], pair[2]]
    function pair_to_list{T<:Any}(pairs::Array{Tuple{T, T}}; split = false)

        len = length(pairs)
        list = nothing

        # initialise array with type
        if typeof(pairs[1][1]) == typeof(pairs[1][2]) list = Array{typeof(pairs[1][1])}(len*2)
        else list =Array{Any}(len*2)
        end

        # flatten tuples one by one
        if split == false
            for i in 1:len
                list[2*i - 1] = pairs[i][1]
                list[2*i] = pairs[i][2]
            end
        # flatten tuples separating the all the first indices and second indices
        elseif split == true
            j = len
            for i in 1:len
                list[i] = pairs[i][1]
                list[j+i] = pairs[i][2]
            end
        else error("split arguement not boolean") end
        return list
    end

end # module