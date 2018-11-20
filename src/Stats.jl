module Stats

    using StatsBase: fit, Histogram

    export binned_sample_constant

    """
    `binned_sample_constant(data, bin_width, num_bin_samples)`

    Bin `data` array into bins of width `bin_width`. Sample a constant `num_bin_samples` number of points from each bin.
    Returns, `sample_inds`, array of indices of original `data` array.

    ### Arguments
    - `data` : array of single numbers
    - `bin_width` : bin width
    - `num_bin_samples` : number of points per bin to sample
    """
    function binned_sample_constant(data, bin_width, num_bin_samples)

        num_bin_samples_arg = num_bin_samples # store original number
        sample_inds = Array{Int}([]) # indices of a sample of the data array

        # fit histogram to data array
        h = fit(Histogram, data, closed=:left, minimum(data):bin_width:maximum(data))

        for i in 2:length(h.edges[1])

            inds = nothing

            # find indices of points in a particular bin in data array
            bin_inds = find(((data .>= h.edges[1][i-1]) .& (data .< h.edges[1][i])) .== true)

            # if not enough points in bin use all points
            if length(bin_inds) <= num_bin_samples
                num_bin_samples = length(bin_inds)
                inds = 1:num_bin_samples

            # if enough points in bin
            elseif length(bin_inds) > num_bin_samples
                # select random points in the array
                inds = unique(rand(1:length(bin_inds), num_bin_samples))

                # length(bin_inds) roughly equal to num_bin_samples
                # so likely not enough unique random points
                if length(inds) < num_bin_samples
                    # select almost evenly distributed (along array) points in the bin
                    inds = Int.(collect(1:floor(length(bin_inds)/num_bin_samples):length(bin_inds)))
                end
                # statement above may produce more numbers than num_bin_samples
                # so ensure correct length of num_bin_samples
                inds = inds[1:num_bin_samples]
            end

            bin_sample = bin_inds[inds] # select sample from bin
            sample_inds = vcat(sample_inds, bin_sample) # concatenate bin samples
            num_bin_samples = num_bin_samples_arg # reset to original number of points to sample per bin
        end

        return sample_inds
    end

end # module