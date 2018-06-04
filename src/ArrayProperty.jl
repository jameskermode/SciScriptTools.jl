module ArrayProperty

    export estimate_y_given_x, monotonically_increasing

    function monotonically_increasing(x::Array{Float64})
        for i in 1:length(x)-1
            if x[i+1] < x[i]
                return false
            end
        end
        return true
    end

    """
    `estimate_y_given_x(x_g::Float64, y::Array{Float64}, x::Array{Float64}; round_dp = 5, verbose = 0)`

    ### Arguements
    - x_g::Float64 : given x
    - y::Array{Float64}
    - x::Array{Float64}
    #### Optional
    - round_dp::Int = 5 : round x array to given decimal places
    - verbose = 0 : 0 = info, 1 = extra information
    """
    function estimate_y_given_x(x_g::Float64, y::Array{Float64}, x::Array{Float64}; round_dp = 5, verbose = 0)

        y_g = false
        
        # organise arrays
        # check if x is monotonically increasing, condtional checks rely this
        mon_in = monotonically_increasing(x)

        if mon_in == false
            y = flipdim(y, 1)
            x = flipdim(x, 1)
        end
        
        # check if given x is within range of x array
        if x_g < x[1] || x_g > x[length(x)]
            warn("x_g = ", x_g, " out of x range")
            warn("x may not be strictly increasing")
            return y_g
        end
        
        # try find exact value
        p = find(x .== x_g )
        if length(p) == 1
            y_g = y[p[1]]
            if verbose == 1 print("x_g = ", x_g, " found an exact y") end
            return y_g
        end
        
        # try find 'exact' value using rounded x array
        p = find(round.(x, round_dp) .== x_g )
        if length(p) == 1
            y_g = y[p[1]]
            if verbose == 1 print("x_g = ", x_g, " using a rounded x, found exact y") end
            return y_g
        end
        
        # find closest points and interpolate between them
        if length(p) == 0
            # find nearest indices, i and i-1
            i = 0
            for i in 1:length(x)
            if x_g < x[i]
                    break
                end
            end
            # linear interpolation, y = mx + c
            Dy = y[i] - y[i - 1]  
            Dx = x[i] - x[i - 1]
            m = Dy/Dx
            c = y[i] - m*x[i]
            y_g = m*x_g + c
            
            if verbose == 1
                print("estimated y: \n")
                @printf "x[l] = %.5e, y[l] = %.5e \n" x[i - 1] y[i - 1]
                @printf "x_g  = %.5e, y_g  = %.5e \n" x_g y_g 
                @printf "x[u] = %.5e, y[u] = %.5e \n" x[i] y[i]
            end
            
            return y_g
        end
        
        if length(p) > 1
            warn("Surjection, x_g = ", x_g, " is not unique in x, given x rounded to ", round_dp, " dp")
            warn("Multiple values of ", x_g, " found in x, can not estimate singular y value")
            return y_g
        end

        return false
    end



end # module