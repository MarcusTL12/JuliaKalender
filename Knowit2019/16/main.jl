

function main()
    startpos = (0, 0)
    
    fjord = open("fjord.txt") do io
        i = 1
        lines = BitArray[]
        for l in eachline(io)
            c = Vector{Char}(l)
            
            for j in 1 : length(c)
                if c[j] == 'B'
                    startpos = (i, j)
                end
            end
            
            push!(lines, BitArray(map(x->x=='#', c)))
            
            i += 1
        end
        hcat(lines...) |> transpose |> copy
    end
    
    speed = -1
    crosses = 1
    h, w = size(fjord)
    
    xpos = startpos[2]
    ypos = startpos[1]
    
    path = falses(h, w)
    
    while xpos < w - 1
        i = 1
        
        while xpos + i <= w && !fjord[ypos + i * speed, xpos + i]
            i += 1
        end
        
        if xpos + i >= w
            break
        end
        
        if i <= 3
            speed *= -1
            crosses += 1
            xpos += 1
        end
        
        xpos += 1
        ypos += speed
    end
    
    crosses
end
