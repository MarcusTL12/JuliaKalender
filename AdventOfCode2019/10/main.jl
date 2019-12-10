
function loadboard(file)
    open(file, "r") do io
        a = [[i == '#' for i in l] for l in eachline(io)]
        [a[i][j] for i in 1 : length(a), j in 1 : length(a[1])]
    end
end


function visibleasteroids(map, pos)
    directions = Set{Tuple{Rational{Int}, Int}}()
    
    h, w = size(map)
    
    for i in 1 : w
        for j in 1 : h
            if map[j, i]
                dx = i - pos[1]
                dy = pos[2] - j
                if dx == dy == 0
                    continue
                end
                
                s = sign(dx)
                if s == 0
                    s = 1
                end
                
                push!(directions, (dy//dx, s))
            end
        end
    end
    directions
end


function vapestroid(map, (x, y), (dy, dx))
    x += dx
    y += dy
    h, w = size(map)
    while 0 < x <= w && 0 < y <= h && !map[y, x]
        x += dx
        y += dy
    end
    
    found = false
    
    if 0 < x <= w && 0 < y <= h
        map[y, x] = false
        found = true
    end
    
    x, y, found
end


function vapeorder(map, pos)
    map = copy(map)
    map[reverse(pos)...] = false
    dir = visibleasteroids(map, pos) |> collect
    sort!(
        dir;
        by=i->(-atan(denominator(i[1]) * i[2], -numerator(i[1]) * i[2]))
    )
    
    i = 1
    
    order = Tuple{Int, Int}[]
    
    while count(map) > 0
        dydx, sgn = dir[i]
        dy, dx = (-numerator(dydx), denominator(dydx)) .* sgn
        x, y, found = vapestroid(map, pos, (dy, dx))
        if found
            push!(order, (x, y))
            i += 1
        else
            deleteat!(dir, i)
            # println("hade")
        end
        if i > length(dir)
            i = 1
            # println("Hei")
        end
    end
    
    order
end


function part1()
    map = loadboard("stian.txt")
    
    h, w = size(map)
    
    rec = 0
    recpos = (0, 0)
    
    for j in 1 : h
        for i in 1 : w
            if map[j, i]
                amtass = visibleasteroids(map, (i, j)) |> length
                if amtass > rec
                    rec = amtass
                    recpos = (i, j)
                end
            end
        end
    end
    rec, recpos .- 1
end


function part2()
    map = loadboard("stian.txt")
    
    _, start = part1()
    
    ord = vapeorder(map, start .+ 1)
    ord[306 - 20] .- 1
end

