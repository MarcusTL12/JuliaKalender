

function main()
    forest = open("forest.txt") do io
        map(
            x->x=='#',
            hcat(
                Vector{Char}.(eachline(io))...
            )
        )
    end
    
    w, h = size(forest)
    
    totlength = 0
    
    for i in 1 : w
        if forest[i, h]
            tree = 1
            while tree < h && forest[i, h - tree]
                tree += 1
            end
            totlength += tree
        end
    end
    
    Int(totlength * 1 // 5 * 200)
end
