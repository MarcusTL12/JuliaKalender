
function main()
    coords = open("coords.csv", "r") do io
        [
            parse.(Int, (m.captures...,))
            for m in eachmatch(r"(\d+),(\d+)", String(read(io)))
        ]
    end
    
    visited = Dict{Tuple{Int, Int}, Int}([(0, 0) => 1])
    time = 0
    pos = (0, 0)
    
    for c in coords
        step = c[1] > pos[1] ? 1 : -1
        for x in pos[1] + step : step : c[1]
            time += if haskey(visited, (x, pos[2]))
                visited[(x, pos[2])] += 1
            else
                push!(visited, (x, pos[2]) => 1)
                1
            end
        end
        
        pos = (c[1], pos[2])
        
        step = c[2] > pos[2] ? 1 : -1
        for y in pos[2] + step : step : c[2]
            time += if haskey(visited, (pos[1], y))
                visited[(pos[1], y)] += 1
            else
                push!(visited, (pos[1], y) => 1)
                1
            end
        end
        
        pos = c
    end
    
    time
end


function main2()
    coords = open(
        io->map(x->(parse.(Int, split(x, ','))...,), eachline(io)),
        "coords.csv", "r"
    )
    
    visited = zeros(Int, 1000, 1000)
    time = 0
    pos = (0, 0)
    
    for c in coords
        step = c[1] > pos[1] ? 1 : -1
        for x in pos[1] + step : step : c[1]
            time += (visited[x + 1, pos[2] + 1] += 1)
        end
        
        pos = (c[1], pos[2])
        
        step = c[2] > pos[2] ? 1 : -1
        for y in pos[2] + step : step : c[2]
            time += (visited[pos[1] + 1, y + 1] += 1)
        end
        
        pos = c
    end
    
    time
end
