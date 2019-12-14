import JSON


function main()
    file = open(JSON.parse, "maze.json")
    
    maze = falses(4, 500, 500)
    
    for i in file
        for j in i
            maze[:, j["y"] + 1, j["x"] + 1] .= (
                j["nord"], j["vest"], j["syd"], j["aust"]
            )
        end
    end
    
    directions = [
        ( 0, -1),   # nord
        (-1,  0),   # vest
        ( 0,  1),   # syd
        ( 1,  0)    # aust
    ]
    
    function findpath(priority)
        visited = falses(500, 500)
        path = Tuple{Int, Int}[]
        
        curpos = (1, 1)
        visited[1, 1] = true
        
        
        while curpos != (500, 500)
            dir = (0, 0)
            for i in priority
                npos = curpos .+ directions[i]
                if !maze[i, curpos[2], curpos[1]] && !visited[npos[2], npos[1]]
                    dir = directions[i]
                end
            end
            
            if dir == (0, 0)
                curpos = pop!(path)
            else
                npos = curpos .+ dir
                visited[npos[2], npos[1]] = true
                push!(path, curpos)
                curpos = npos
            end
        end
        
        path
        
        count(visited)
    end
    
    arthur = [3, 4, 2, 1]
    isaac  = [4, 3, 2, 1]
    
    abs(findpath(arthur) - findpath(isaac))
end
