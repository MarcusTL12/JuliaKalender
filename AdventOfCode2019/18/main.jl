using Memoize

function bfs(
    maze, pos, keypos = Tuple{Int, Int}[], pathdirs = Dict([pos => (0, 0)])
)
    queue = [pos]
    
    dirs = [
        ( 0,  1),
        ( 1,  0),
        ( 0, -1),
        (-1,  0)
    ]
    
    while length(queue) > 0
        curpos = pop!(queue)
        for d in dirs
            npos = curpos .+ d
            if !haskey(pathdirs, npos)
                cell = maze[npos...]
                if cell != '#' && !isuppercase(cell)
                    if islowercase(cell)
                        push!(keypos, npos)
                    end
                    pushfirst!(queue, npos)
                    pathdirs[npos] = (0 .- d)
                end
            end
        end
    end
    
    keypos, pathdirs
end


function makepath(pathdirs, pos)
    path = [pos]
    
    while pathdirs[pos] != (0, 0)
        pos = pathdirs[pos] .+ pos
        pushfirst!(path, pos)
    end
    
    path
end


function moveto(maze, pathdirs, pos)
    maze = copy(maze)
    path = makepath(pathdirs, pos)
    for npos in path
        if maze[npos...] |> islowercase
            doors = indexin(uppercase(maze[npos...]), maze)[]
            if doors != nothing
                maze[doors] = '.'
            end
            maze[npos...] = '.'
        end
    end
    maze, length(path) - 1, path[1]
end


totcalls = 0


function solve(maze_, pos_)
    mem = Dict{typeof((maze_, pos_)), Int}()
    
    function rec(maze, pos)
        if haskey(mem, (maze, pos))
            return mem[(maze, pos)]
        end
        
        keypos, pathdirs = bfs(maze, pos)
        
        bestl = 0
        
        for p in keypos
            nmaze, l = moveto(maze, pathdirs, p)
            l += rec(nmaze, p)
            
            if bestl == 0
                bestl = l
            elseif l < bestl
                bestl = l
            end
        end
        
        mem[maze, pos] = bestl
        
        bestl
    end
    
    rec(maze_, pos_)
end


function part1()
    maze = open("input.txt") do io
        temp = Vector{Char}.(
            split(String(read(io)), '\n')
        )
        
        [temp[j][i] for j in 1 : length(temp), i in 1 : length(temp[1])]
    end
    
    pos = indexin('@', maze)[].I
    
    solve(maze, pos)
end


function solvep2(maze_, poss_)
    mem = Dict{typeof((maze_, poss_)), Int}()
    
    function rec(maze, poss)
        if haskey(mem, (maze, poss))
            return mem[(maze, poss)]
        end
        
        keypos, pathdirs = bfs(maze, poss[1])
        
        for pos in poss[2 : end]
            bfs(maze, pos, keypos, pathdirs)
            
            pathdirs[pos] = (0, 0)
        end
        
        bestl = 0
        
        for p in keypos
            nmaze, l, pm = moveto(maze, pathdirs, p)
            
            npss = if pm == poss[1]
                (p, poss[2:end]...)
            elseif pm == poss[2]
                (poss[1], p, poss[3], poss[4])
            elseif pm == poss[3]
                (poss[1], poss[2], p, poss[4])
            elseif pm == poss[4]
                (poss[1:3]..., p)
            else
                @assert false
            end
            
            l += rec(nmaze, npss)
            
            if bestl == 0
                bestl = l
            elseif l < bestl
                bestl = l
            end
        end
        
        mem[(maze, poss)] = bestl
        
        bestl
    end
    
    rec(maze_, poss_)
end


function part2()
    maze = open("inputpart2.txt") do io
        temp = Vector{Char}.(
            split(String(read(io)), '\n')
        )
        
        [temp[j][i] for j in 1 : length(temp), i in 1 : length(temp[1])]
    end
    
    poss = Tuple{Int, Int}[]
    
    h, w = size(maze)
    
    for i in 1 : h
        for j in 1 : w
            if maze[i, j] == '@'
                push!(poss, (i, j))
            end
        end
    end
    
    solvep2(maze, (poss...,))
end

