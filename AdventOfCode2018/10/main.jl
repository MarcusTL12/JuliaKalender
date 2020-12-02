

function loadinput(filename)
    reg = r"position=<\s*(-?\d+),\s*(-?\d+)> velocity=<\s*(-?\d+),\s*(-?\d+)>"
    open(filename) do io
        pos, vel = NTuple{2, Int}[], NTuple{2, Int}[]
        for l in eachline(io)
            p1, p2, v1, v2 = parse.(Int, match(reg, l).captures)
            
            push!(pos, (p1, p2))
            push!(vel, (v1, v2))
        end
        
        pos, vel
    end
end


function renderpositions(pos)
    pos_set = Set(pos)
    
    minx = minimum(x->x[1], pos)
    miny = minimum(x->x[2], pos)
    
    maxx = maximum(x->x[1], pos)
    maxy = maximum(x->x[2], pos)
    
    for i in miny : maxy
        for j in minx : maxx
            if (j, i) in pos_set
                print('█')
            else
                print(' ')
            end
        end
        println()
    end
end


function normofpos(pos)
    minx = minimum(x->x[1], pos)
    miny = minimum(x->x[2], pos)
    
    maxx = maximum(x->x[1], pos)
    maxy = maximum(x->x[2], pos)
    
    sqrt((maxx - minx)^2 + (maxy - miny)^2)
end


function applyvel!(pos, vel)
    for i in 1 : length(pos)
        pos[i] = pos[i] .+ vel[i]
    end
end


function applynegvel!(pos, vel)
    for i in 1 : length(pos)
        pos[i] = pos[i] .- vel[i]
    end
end


function part1n2()
    pos, vel = loadinput("input.txt")
    
    lastnorm = normofpos(pos)
    applyvel!(pos, vel)
    
    i = 0
    
    while (n = normofpos(pos)) < lastnorm
        applyvel!(pos, vel)
        lastnorm = n
        i += 1
    end
    
    applynegvel!(pos, vel)
    renderpositions(pos)
    i
end

