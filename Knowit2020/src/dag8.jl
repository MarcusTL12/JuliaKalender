

reg = r"(.+): \((\d+), (\d+)\)"


function main()
    locations = Dict{String,Tuple{Int,Int}}()
    timer = Dict{String, Rational{Int}}()
    tour = String[]
    open("inputfiles/dag8/input.txt") do io
        for l in eachline(io)
            m = match(reg, l)
            
            if !isnothing(m)
                location = m.captures[1]
                pos = (parse(Int, m.captures[2]), parse(Int, m.captures[3]))
                locations[location] = pos
                timer[location] = 0
            else
                push!(tour, l)
            end
        end
    end
    
    pos = (0, 0)
    for loc in tour
        npos = locations[loc]
        while pos[1] != npos[1]
            pos = pos .+ (sign(npos[1] - pos[1]), 0)
            
            for place in keys(timer)
                dist = sum(abs, locations[place] .- pos)
                
                timer[place] += if dist == 0
                    0//1
                elseif dist < 5
                    1//4
                elseif dist < 20
                    1//2
                elseif dist < 50
                    3//4
                else
                    1//1
                end
            end
        end
        
        while pos[2] != npos[2]
            pos = pos .+ (0, sign(npos[2] - pos[2]))
            
            for place in keys(timer)
                dist = sum(abs, locations[place] .- pos)
                
                timer[place] += if dist == 0
                    0//1
                elseif dist < 5
                    1//4
                elseif dist < 20
                    1//2
                elseif dist < 50
                    3//4
                else
                    1//1
                end
            end
        end
    end
    
    maximum(values(timer)) - minimum(values(timer))
end
