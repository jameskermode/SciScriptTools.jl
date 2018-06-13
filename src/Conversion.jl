module Conversion

    export dict_convert_keys

    """
    `dict_convert_keys(dict)`

    'Converts' dictionary keys of strings/symbols to keys of symbols/strings
    Returns new dictionary.
    """
    function dict_convert_keys(dict)
        
        dk = dict.keys
        if typeof(dk) == Array{String,1} t = "t_string" end
        if typeof(dk) == Array{Any,1} t = "t_symbol" end # using type Symbols creates dictionary of Array{Any,1}
        
        dict_c = Dict()
        for i in 1:length(dk)
            # dict.keys have lots of `#undef` elements and will throw error onces accessed with dict.keys[i]
            # thus avoid error with try catch block 
            try
                if t == "t_string" dict_c[Symbol(dk[i])] = dict[dk[i]] end
                if t == "t_symbol" dict_c[String(dk[i])] = dict[dk[i]] end
            catch
            end
        end

        return dict_c 
    end

end # module