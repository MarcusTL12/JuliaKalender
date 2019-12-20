

loaddata(filename) = parse.(Int, split(open(String ∘ read, filename)))


function part1()
    data = loaddata("input.txt")
    
    function metasum(i)
        children = data[i]
        meta = data[i + 1]
        i += 2
        ltot = 2 + meta
        msum = 0
        for _ in 1 : children
            m, l = metasum(i)
            i += l
            ltot += l
            msum += m
        end
        
        for _ in 1 : meta
            msum += data[i]
            i += 1
        end
        
        msum, ltot
    end
    
    metasum(1)[1]
end


function part2()
    data = loaddata("input.txt")
    
    function nodeval(i)
        children = data[i]
        meta = data[i + 1]
        i += 2
        ltot = 2 + meta
        childvals = zeros(Int, children)
        for j in 1 : children
            v, l = nodeval(i)
            i += l
            ltot += l
            childvals[j] = v
        end
        val = if children > 0
            sum(
                1 <= j <= children ? childvals[j] : 0
                for j in data[i : i + meta - 1]
            )
        else
            sum(data[i : i + meta - 1])
        end
        val, ltot
    end
    
    nodeval(1)[1]
end
