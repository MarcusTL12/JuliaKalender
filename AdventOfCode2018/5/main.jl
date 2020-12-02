

function singlepass(pol)
    i = length(pol)
    annihilated = Int[]
    while i > 1
        if lowercase(pol[i]) == lowercase(pol[i - 1])
            if islowercase(pol[i]) ⊻ islowercase(pol[i - 1])
                push!(annihilated, i)
                push!(annihilated, i - 1)
                i -= 1
            end
        end
        
        i -= 1
    end
    
    annihilated
end


function multipass!(pol)
    while (a = singlepass(pol)) |> length > 0
        for i in a
            deleteat!(pol, i)
        end
    end
end


function part1()
    pol = open(Vector{Char} ∘ String ∘ read, "input.txt")
    
    multipass!(pol)
    
    pol |> length
end


function part2()
    pol = open(Vector{Char} ∘ String ∘ read, "input.txt")
    
    units = Set(lowercase.(pol))
    
    l = length(pol)
    
    for c in units
        npol = filter(x->lowercase(x) != c, pol)
        multipass!(npol)
        
        nl = length(npol)
        if nl < l
            l = nl
        end
    end
    
    l
end
