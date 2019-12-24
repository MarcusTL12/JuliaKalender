

p2bits(s) = Vector{Char}(s) .== '#'


function loadinput(filename)
    s = open(String ∘ read, filename)
    
    growdict = Dict{BitArray{1}, Bool}()
    
    for m in eachmatch(r"(.+) => (.)", s)
        c1, c2 = m.captures
        growdict[p2bits(c1)] = c2 == "#"
    end
    
    state = p2bits(match(r"initial state: ([#.]+)", s).captures[])
    
    growdict
    
    # Dict((0 : length(state) - 1) .=> state), growdict
    state, growdict
end


function part1()
    state, growdict = loadinput("input.txt")
    
    
end


function part2()
    
end
