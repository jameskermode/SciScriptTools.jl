module Stats

    using StatsBase: fit, Histogram

    export binned_subsample_constant

    """
    `binned_subsample_constant(data, bin_width, bin_subsample)`

    Bin `data` array into bins of width `bin_width`. Sample a constant `bin_subsample` number of points from each bin. 
    Returns array of indices of original `data` array

    ### Arguments
    - `data` : array of single numbers
    - `bin_width` : bin width
    - `bin_subsample` : number of points per bin to sample
    """
    function binned_subsample_constant(data, bin_width, bin_subsample)
    
        bin_subsample_arg = bin_subsample
        
        subsample = Array{Int}([])
        # fit histogram to data array
        h = fit(Histogram, data, closed=:left, minimum(data):bin_width:maximum(data))
        for i in 2:length(h.edges[1])
            # find indices of points in a particular bin in data array
            bin_inds = find(((data .>= h.edges[1][i-1]) 
                    .& (data .< h.edges[1][i])) .== true)
            # if not enough points in bin use all points
            if length(bin_inds) < bin_subsample bin_subsample = length(bin_inds) end
            # select almost evenly distributed (along array) points in the bin
            bin_sample = bin_inds[Int.(collect(1:floor(length(bin_inds)/bin_subsample):length(bin_inds)))]
            subsample = vcat(subsample, bin_sample) # concatenate subsamples
            bin_subsample = bin_subsample_arg # reset to original number of points to sample per bin
        end
        
        return subsample
    end

end # module