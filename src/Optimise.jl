module Optimise

    using Logging: debug, info, error 

    export bisection_search

    # Logging
    # to display logging levels, use
    # `using Logging: DEBUG`
    # `Logging.configure(level=DEBUG)`

    """
    `bisection_search(points::Array{Float64}, dir_next::Int, directions::Array{Int};
                                search_scale::Float64 = 0.1)`

    (Logic to) Optimise a parameter's value via a bisection method.
    Also allows for a single initial point which will search for an interval then bisect.
    Conditional statements for choosing whether to select the more positive or more negative 
    halves is done outside the function and the decision is passed in via `dir_next`
    
    ### Usage
    - Interval start (note interval is exclusive of a and b)
    ```
    points = Array{Float64}([a, b])
    directions = nothing # need to create, function will initialise
    dir_next = nothing    # need to create, function will initialise

    for i in 1:maxsteps

        point, points, directions = bisection_search(points, dir_next, directions)

        # main code using point (as parameter)
        # condtional statements to choose dir_next of point, either 1 or -1
    end
    ```
    - Single value start 
    ```
    points = Array{Float64}([point_initial])
    directions = nothing # need to create, function will initialise
    dir_next = nothing   # can create, note call of function after `dir_next` is choosen
    for i in 1:maxsteps

        point = points[length(points)]
        # main code using point (as parameter)
        # condtional statements to choose dir_next of point, either 1 or -1

        point, points, directions = bisection_search(points, dir_next, directions)
    end
    ```
    ### Arguments
    - `points::Array{Float64}` : history of points, initially the starting value
    - `dir_next::Int` : next direction to search/(eventually) bisect in, 
                            1 => positive direction ie point * (1+search_scale),
                            -1 => negative direction ie point * (1-search_scale)
    - `directions::Array{Int}` : history of directions

    #### Optional 
    - `search_scale::Float64 = 0.1` : +- percentage to scale point when searching new territory

    ### Returns
    - `point::Float64`  :  new searched/bisected value
    - `points::Array{Float64}` : updated history to be passed back in
    - `directions::Array{Int}` : updated direction history to be passed back in
    """
    function bisection_search(points::Array{Float64}, dir_next::Int, directions::Array{Int};
                                search_scale::Float64 = 0.1)
            
        debug("function: bisection_search()")

        # check for a valid dir_next value
        if (dir_next == 1 || dir_next == -1) == false 
            error("Invalid dir_next value, should be 1 or -1 \nreceived dir_next = ", dir_next)
        end

        # decide whether it should search or bisect
        dir_c = copy(directions); push!(dir_c, dir_next) # to include next direction
        ud = unique(dir_c)
        bisect_b = false # accounts for if length(ud) == 1 ie directions array only has 0 in it
        if length(ud) == 2 bisect_b = false end # implies search still in one direction
        if length(ud) == 3 bisect_b = true end # implies a bisection is required so interval exists
        
        p_len = length(points)
        point = points[p_len]
            
        # search section: move in a certain direction
        if bisect_b == false
            debug("searching")
            if dir_next == 1 point = point * (1+search_scale) 
            elseif dir_next == -1 point = point * (1-search_scale)
            end
        # bisection section
        elseif bisect_b == true
            # find bisect_indices, what interval to choose, given history and previous directions
            debug("bisection")
            debug("index of interval point: ", findlast(directions, dir_next*-1)-1)
            # find in the historical directions list the last occurence of opposite sign of dir_next - 1
            # this is the new other bound of the interval to intersect
            bisect_indices = (findlast(directions, dir_next*-1)-1, p_len)
            debug("bisect indices: ", bisect_indices)
            debug("interval: ", [points[bisect_indices[1]], points[bisect_indices[2]]])
            point = (abs(0.5*(points[bisect_indices[2]] - points[bisect_indices[1]])) 
                                + minimum([points[bisect_indices[1]], points[bisect_indices[2]]]))
        end

        push!(points, point)
        push!(directions, dir_next)

        return point, points, directions
    end
    # function to initialise arrays when using this function
    # only called the first time in a loop, other occurences will call the above function
    function bisection_search(points::Array{Float64}, dir_next, directions;
                                                    search_scale::Float64 = 0.1)
        # initialise single value start
        if length(points) == 1 
            info("single point, will serach then bisect")
            if (dir_next == 1 || dir_next == -1) == false 
                error("need to decide dir_next before calling bisection_search()")
            end
            directions = Array{Int}([0])
        # initialise interval start
        elseif length(points) == 2
            info("interval given, will bisect")
            points = Array{Float64}([minimum(points), maximum(points)])
            dir_next = Int(-1)
            directions = Array{Int}([0, 1])
        elseif length(points) > 2 error("too many points given, give two points or single point")
        end

        return bisection_search(points, dir_next, directions; search_scale = search_scale)
    end


end # module