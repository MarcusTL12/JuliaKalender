using Base.Iterators


function main()
    inp = open(String ∘ read, "inputfiles/dag5/rute.txt")
    
    pos = (0, 0)
    
    vertices = Tuple{Int,Int}[]
    last_dir = (0, 0)
    
    for dir in inp
        dir_vec = if dir == 'H'
            (1, 0)
        elseif dir == 'V'
            (-1, 0)
        elseif dir == 'O'
            (0, 1)
        else
            (0, -1)
        end
        if last_dir != dir_vec
            push!(vertices, pos)
        end
        last_dir = dir_vec
        pos = pos .+ dir_vec
    end
    
    area = 0
    for ((a, b), (c, d)) in zip(vertices, drop(vertices, 1))
        area += a * d - b * c
    end
    area ÷ 2
end
