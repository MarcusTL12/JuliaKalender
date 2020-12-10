

dirs = [(-1, 0), (1, 0), (0, 1), (0, -1)]

function do_step(from, to)
    w, h = size(from)
    did_something = false
    for i in 1:w, j in 1:h
        if !from[i, j] &&
            count(get(from, (i, j) .+ d, false) for d in dirs) >= 2
            did_something = true
            to[i, j] = true
        else
            to[i, j] = from[i, j]
        end
    end
    did_something
end

function main()
    inp = open("inputfiles/dag9/elves.txt") do io
        buf = falses(0)
        w = h = 0
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(buf, c == 'S' for c in l)
        end
        reshape(buf, (w, h))
    end
    
    other = copy(inp)
    i = 1
    
    while do_step(inp, other)
        inp, other = other, inp
        i += 1
    end
    
    i
end
