include("../intcode.jl")

function makemaze(mazedict)
    topleftx = minimum((k[1] for k in keys(mazedict)))
    toplefty = minimum((k[1] for k in keys(mazedict)))
    
    bottomrightx = maximum((k[1] for k in keys(mazedict)))
    bottomrighty = maximum((k[1] for k in keys(mazedict)))
    
    offset = (-topleftx + 1, -toplefty + 1)
    
    w = bottomrightx - topleftx + 1
    h = bottomrighty - toplefty + 1
    
    maze = trues(h, w)
    
    for ((x, y), v) in mazedict
        (x, y) = (x, y) .+ offset
        maze[y, x] = v != 0
    end
    
    maze, offset
end


function rendermaze(maze, pos, goal, ioout=stdout)
    h, w = size(maze)
    
    io = IOBuffer()
    
    for i in 1 : h
        for j in 1 : w
            if (j, i) == pos
                print(io, ":D")
            elseif (j, i) == goal
                print(io, "░░")
            else
                print(io, maze[i, j] ? "██" : "  ")
            end
        end
        println(io, "")
    end
    
    print(ioout, String(take!(io)))
end


function mapmaze(program)
    out, done, state = runintcode!(program)
    
    maze = Dict([(0, 0) => 0])
    
    curpos = (0, 0)
    
    path = Int[]
    
    directions = [
        ( 0, -1),
        ( 0,  1),
        (-1,  0),
        ( 1,  0)
    ]
    
    reversepath = [2, 1, 4, 3]
    
    target = (0, 0)
    
    pathlen = 0
    
    while !done
        dir = 0
        
        for i in 1 : 4
            if !haskey(maze, curpos .+ directions[i])
                dir = i
                break
            end
        end
        
        if dir == 0
            if length(path) == 0
                break
            else
                backdir = reversepath[pop!(path)]
                out, done, state = runintcode!(program, [backdir], state)
                curpos = curpos .+ directions[backdir]
                
                @assert out[] == 1
            end
        else
            out, done, state = runintcode!(program, [dir], state)
            if out[] == 0
                maze[curpos .+ directions[dir]] = 1
            elseif out[] == 1
                curpos = curpos .+ directions[dir]
                maze[curpos] = 0
                push!(path, dir)
            elseif out[] == 2
                curpos = curpos .+ directions[dir]
                target = curpos
                maze[curpos] = 2
                push!(path, dir)
                pathlen = length(path)
            else
                println("The fuck!?")
                break
            end
        end
    end
    
    maze, pathlen, target
end


function findanddrawmaze()
    program = loadprogram("input.txt")
    
    maze, _, oxygen = mapmaze(program)
    
    maze, offset = makemaze(maze)
    
    oxygen = oxygen .+ offset
    
    rendermaze(maze, offset, oxygen)
end


function part1()
    program = loadprogram("input.txt")
    
    _, pathlen, _ = mapmaze(program)
    
    pathlen
end


function part2()
    program = loadprogram("input.txt")
    
    maze, _, oxygen = mapmaze(program)
    
    maze, offset = makemaze(maze)
    
    visited = falses(size(maze))
    
    oxygen = oxygen .+ offset
    
    directions = [
        ( 0, -1),
        ( 0,  1),
        (-1,  0),
        ( 1,  0)
    ]
    
    visited[reverse(oxygen)...] = true
    queue = [(oxygen, 0)]
    
    maxlen = 0
    
    while length(queue) > 0
        curpos, curlen = popfirst!(queue)
        if curlen > maxlen
            maxlen = curlen
        end
        
        for i in 1 : 4
            if !maze[reverse(curpos .+ directions[i])...] &&
                !visited[reverse(curpos .+ directions[i])...]
                push!(queue, (curpos .+ directions[i], curlen + 1))
                visited[reverse(curpos .+ directions[i])...] = true
            end
        end
    end
    
    maxlen
end
