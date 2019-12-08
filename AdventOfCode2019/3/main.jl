
const dirmap = Dict([
    'R' => Complex{Int}(1, 0),
    'L' => Complex{Int}(-1, 0),
    'U' => Complex{Int}(0, 1),
    'D' => Complex{Int}(0, -1)
])


function parsemove(move)
    dirmap[move[1]], parse(Int, SubString(move, 2, length(move)))
end


function findclosest(crosses)
    curmin = nothing
    for i in crosses
        if curmin === nothing
            curmin = i
        elseif (abs(real(i)) + abs(imag(i)) <
            abs(real(curmin)) + abs(imag(curmin)))
            curmin = i
        end
    end
    curmin
end


function findclosestintersect()
    p1, p2 = split.(
        open(collect ∘ eachline, "input2.txt", "r"),
        ","
    )
    
    p1 = parsemove.(p1)
    p2 = parsemove.(p2)
    
    p1′ = Complex{Int}[]
    p2′ = Complex{Int}[]
    
    for (d, l) in p1
        for i in 1 : l
            push!(p1′, d)
        end
    end
    
    for (d, l) in p2
        for i in 1 : l
            push!(p2′, d)
        end
    end
    
    p1 = p1′
    p2 = p2′
    
    accumulate!.(+, (p1, p2), (p1, p2))
    
    p1 = Set(p1)
    p2 = Set(p2)
    
    crosses = p1 ∩ p2
    
    cl = findclosest(crosses)
    cl, (abs(real(cl)) + abs(imag(cl)))
end


function findfirstintersect()
    p1, p2 = split.(
        open(collect ∘ eachline, "input2.txt", "r"),
        ","
    )
    
    p1 = parsemove.(p1)
    p2 = parsemove.(p2)
    
    p1′ = Tuple{Complex{Int}, Int}[]
    p2′ = Tuple{Complex{Int}, Int}[]
    
    let lbuff = 0
        for (d, l) in p1
            for i in 1 : l
                push!(p1′, (d, lbuff += 1))
            end
        end
        
        lbuff = 0
        
        for (d, l) in p2
            for i in 1 : l
                push!(p2′, (d, lbuff += 1))
            end
        end
    end
    
    p1 = p1′
    p2 = p2′
    
    accumulate!.((a, b)->(a[1] + b[1], b[2]), (p1, p2), (p1, p2))
    
    p1map = Dict{Complex{Int}, Int}()
    p2map = Dict{Complex{Int}, Int}()
    
    for (p, l) in p1
        if !haskey(p1map, p)
            push!(p1map, p => l)
        elseif p1map[p] > l
            p1map[p] = l
        end
    end
    
    for (p, l) in p2
        if !haskey(p2map, p)
            push!(p2map, p => l)
        elseif p2map[p] > l
            p2map[p] = l
        end
    end
    
    crosses = keys(p1map) ∩ keys(p2map)
    
    first = nothing
    dist = nothing
    
    for p in crosses
        ndist = p1map[p] + p2map[p]
        if first === nothing
            first = p
            dist = ndist
        elseif ndist < dist
            first = p
            dist = ndist
        end
    end
    
    first, dist
end

