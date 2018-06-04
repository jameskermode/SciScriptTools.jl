module Comparison

export percentage_diff

function percentage_diff(a, b)
    return ((b - a) / a) * 100
 end


end # module