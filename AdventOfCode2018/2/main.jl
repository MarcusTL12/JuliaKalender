

function countchars(s)
    s = Vector{Char}(s)
    chars = Set(s)
    
    c1 = false
    c2 = false
    
    for c in chars
        cnt = count(x->x==c, s)
        if cnt == 2
            c1 = true
        elseif cnt == 3
            c2 = true
        end
    end
    c1, c2
end


function part1()
    counts = open(io->countchars.(eachline(io)), "input.txt")
    count(x->x[1], counts) * count(x->x[2], counts)
end


function howdifferent(s1, s2)
    c = 0
    for (a, b) in zip(Vector{Char}.((s1, s2))...)
        a != b && (c += 1)
    end
    c
end


function fuse(s1, s2)
    ret = Char[]
    for (a, b) in zip(Vector{Char}.((s1, s2))...)
        a == b && push!(ret, a)
    end
    String(ret)
end


function part2()
    s = open(collect ∘ eachline, "input.txt")
    
    for i in 1 : length(s)
        for j in i + 1 : length(s)
            if howdifferent(s[i], s[j]) == 1
                return fuse(s[i], s[j])
            end
        end
    end
end
