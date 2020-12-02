

function loadmaze(filename)
    open(filename) do io
        permutedims(hcat(Vector{Char}.(collect(eachline(io)))...), (2, 1))
    end
end


function rendermaze(maze)
    h, w = size(maze)
    for i in 1 : h
        for j in 1 : w
            print(maze[i, j])
        end
        println()
    end
end


function findportals(maze)
    h, w = size(maze)
    
    dirs = [
        ( 1,  0),
        (-1,  0),
        ( 0,  1),
        ( 0, -1)
    ]
    
    portalqueue = Dict{String, Tuple{Int, Int}}()
    
    portals = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()
    
    debdict = Dict{String, Int}()
    
    for i in 2 : h - 1, j in 2 : w - 1
        if isuppercase(maze[i, j])
            otherletter = maze[i, j]
            portalcoord = (0, 0)
            parity = false
            
            for ind in 1 : length(dirs)
                d = dirs[ind]
                cell = maze[((i, j) .+ d)...]
                if isuppercase(cell)
                    otherletter = cell
                    if ind == 2 || ind == 4
                        parity = true
                    end
                elseif cell == '.'
                    portalcoord = (i, j) .+ d
                end
            end
            
            k = if parity
                String([otherletter, maze[i, j]])
            else
                String([maze[i, j], otherletter])
            end
            
            if portalcoord != (0, 0)
                if !haskey(debdict, k)
                    debdict[k] = 1
                else
                    debdict[k] += 1
                end
                if haskey(portalqueue, k)
                    othercoord = portalqueue[k]
                    delete!(portalqueue, k)
                    portals[portalcoord] = othercoord
                    portals[othercoord] = portalcoord
                else
                    portalqueue[k] = portalcoord
                end
            end
        end
    end
    
    # display(debdict)
    
    portals, portalqueue["AA"], portalqueue["ZZ"]
end


function findportalsrec(maze)
    h, w = size(maze)
    
    dirs = [
        ( 1,  0),
        (-1,  0),
        ( 0,  1),
        ( 0, -1)
    ]
    
    portalqueue = Dict{String, Tuple{Tuple{Int, Int}, Int}}()
    
    portals = Dict{Tuple{Int, Int}, Tuple{Tuple{Int, Int}, Int}}()
    
    for i in 2 : h - 1, j in 2 : w - 1
        if isuppercase(maze[i, j])
            inner = (3 < i < h - 3) && (3 < j < w - 3)
            layerdir = inner ? 1 : -1
            
            otherletter = maze[i, j]
            portalcoord = (0, 0)
            parity = false
            
            for ind in 1 : length(dirs)
                d = dirs[ind]
                cell = maze[((i, j) .+ d)...]
                if isuppercase(cell)
                    otherletter = cell
                    if ind == 2 || ind == 4
                        parity = true
                    end
                elseif cell == '.'
                    portalcoord = (i, j) .+ d
                end
            end
            
            k = if parity
                String([otherletter, maze[i, j]])
            else
                String([maze[i, j], otherletter])
            end
            
            if portalcoord != (0, 0)
                if haskey(portalqueue, k)
                    othercoord, otherdir = portalqueue[k]
                    delete!(portalqueue, k)
                    portals[portalcoord] = (othercoord, layerdir)
                    portals[othercoord] = (portalcoord, otherdir)
                else
                    portalqueue[k] = (portalcoord, layerdir)
                end
            end
        end
    end
    
    portals, portalqueue["AA"], portalqueue["ZZ"]
end


function part1()
    maze = loadmaze("input.txt")
    
    portals, entrance, exit = findportals(maze)
    
    queue = [entrance]
    
    pathdict = Dict([entrance => (0, 0)])
    
    dirs = [
        ( 1,  0),
        (-1,  0),
        ( 0,  1),
        ( 0, -1)
    ]
    
    while !haskey(pathdict, exit)
        node = pop!(queue)
        for d in dirs
            nnode = node .+ d
            if !haskey(pathdict, nnode)
                val = maze[nnode...]
                if val != '#'
                    if isuppercase(val) && node != entrance
                        otherside = portals[node]
                        if otherside ∉ keys(pathdict)
                            pathdict[otherside] = node
                            pushfirst!(queue, otherside)
                        end
                    elseif val == '.'
                        pathdict[nnode] = node
                        pushfirst!(queue, nnode)
                    end
                end
            end
        end
    end
    
    path = let curpos = exit
        path = Tuple{Int, Int}[]
        while curpos != (0, 0)
            pushfirst!(path, curpos)
            curpos = pathdict[curpos]
        end
        path
    end
    
    for p in path
        maze[p...] = '█'
    end
    
    rendermaze(maze)
    
    length(path) - 1
end


function part2()
    maze = loadmaze("input.txt")
    
    portals, (entrance, _), (exit, _) = findportalsrec(maze)
    
    queue = [(entrance, 0)]
    
    pathdict = Dict([(entrance, 0) => ((0, 0), -1)])
    
    dirs = [
        ( 1,  0),
        (-1,  0),
        ( 0,  1),
        ( 0, -1)
    ]
    
    while !haskey(pathdict, (exit, 0)) && !isempty(queue)
        node, layer = pop!(queue)
        for d in dirs
            nnode = node .+ d
            if !haskey(pathdict, (nnode, layer))
                val = maze[nnode...]
                if val != '#'
                    if isuppercase(val)
                        if haskey(portals, node)
                            otherside, layerdir = portals[node]
                            if 0 <= layer + layerdir # <= maxdepth
                                nnodel = (otherside, layer + layerdir)
                                if !haskey(pathdict, nnodel)
                                    pathdict[nnodel] = (node, layer)
                                    pushfirst!(queue, nnodel)
                                end
                            end
                        end
                    elseif val == '.'
                        pathdict[(nnode, layer)] = (node, layer)
                        pushfirst!(queue, (nnode, layer))
                    end
                end
            end
        end
    end
    
    if !haskey(pathdict, (exit, 0))
        println("Did not find path!")
        return
    end
    
    path = let curpos = (exit, 0)
        path = Tuple{Int, Int}[]
        while curpos != ((0, 0), -1)
            pushfirst!(path, curpos[1])
            curpos = pathdict[curpos]
        end
        path
    end
    
    # for p in path
    #     maze[p...] = '█'
    # end
    
    # rendermaze(maze)
    
    length(path) - 1
end

