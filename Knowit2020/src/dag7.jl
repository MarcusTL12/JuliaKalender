

function main()
    forest = open("inputfiles/dag7/forest.txt") do io
        map = falses(0)
        w = 0
        h = 0
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(map, (c == '#' for c in l))
        end
        reshape(map, (w, h))[:,end:-1:1]
    end
    
    w, h = size(forest)
    
    count(begin
        tree_width = 0
        is_symmetric = true
        while i - tree_width >= 1 && i + tree_width <= w && is_symmetric &&
            count(@view forest[i + tree_width, 1:end]) > 0
            is_symmetric = (@view forest[i - tree_width, 1:end]) ==
                           (@view forest[i + tree_width, 1:end])
            tree_width += 1
        end
        is_symmetric
    end for i in 1:w if forest[i, 1])
end
