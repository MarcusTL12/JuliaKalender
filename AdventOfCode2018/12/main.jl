

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


function plantsum(plants, padding)
    acc = 0
    
    for i in 1 : length(plants)
        if plants[i]
            acc += i - padding - 1
        end
    end
    acc
end


function part1()
    state, growdict = loadinput("input.txt")
    
    padding = 30
    
    plants = falses(2 * padding + length(state))
    buffer = falses(2 * padding + length(state))
    
    plants[padding + 1 : padding + length(state)] .= state
    
    for _ in 1 : 20
        for i in 3 : length(plants) - 2
            buffer[i] = growdict[plants[i - 2 : i + 2]]
        end
        
        temp = buffer
        buffer = plants
        plants = temp
    end
    
    plantsum(plants, padding)
end


function part2()
    state, growdict = loadinput("input.txt")
    
    padding = 1000
    
    plants = falses(2 * padding + length(state))
    buffer = falses(2 * padding + length(state))
    
    plants[padding + 1 : padding + length(state)] .= state
    
    orig = plantsum(plants, padding)
    
    i = 0
    
    psum = 0
    s = 0
    
    for _ in 1 : 200
        for i in 3 : length(plants) - 2
            buffer[i] = growdict[plants[i - 2 : i + 2]]
        end
        
        temp = buffer
        buffer = plants
        plants = temp
        
        i += 1
        
        s = plantsum(plants, padding)
        println(s - psum)
        if s - psum == 102
            break
        end
        psum = s
    end
    
    (50_000_000_000 - 200 - 1) * 102 + s
end
