include("../intcode.jl")


function part1()
    program = loadprogram("input.txt")
    
    programs = [
        [copy(program), false, (0, 0)]
        for _ in 1 : 50
    ]
    
    function runprogn(i, inp)
        out, programs[i][2], programs[i][3] =
        runintcode!(programs[i][1], inp, programs[i][3])
        out
    end
    
    for i in 1 : length(programs)
        runprogn(i, [i - 1])
    end
    
    packetqueue = [Int[] for _ in 1 : length(programs)]
    
    done = false
    result = -1
    
    while !done
        for i in 1 : length(programs)
            inp = if length(packetqueue[i]) > 0
                packetqueue[i]
            else
                [-1]
            end
            out = runprogn(i, inp)
            if length(out) > 0
                for (ad, x, y) in eachcol(reshape(out, 3, length(out) ÷ 3))
                    if ad == 255
                        done = true
                        result = y
                    else
                        push!(packetqueue[ad + 1], x)
                        push!(packetqueue[ad + 1], y)
                    end
                end
            end
        end
    end
    
    result
end


function part2()
    program = loadprogram("input.txt")
    
    programs = [
        [copy(program), false, (0, 0)]
        for _ in 1 : 50
    ]
    
    function runprogn(i, inp)
        out, programs[i][2], programs[i][3] =
        runintcode!(programs[i][1], inp, programs[i][3])
        out
    end
    
    for i in 1 : length(programs)
        runprogn(i, [i - 1])
    end
    
    packetqueue = [Int[] for _ in 1 : length(programs)]
    
    nat = [0, 0]
    
    prevnaty = 0
    
    done = false
    result = -1
    
    idle = false
    
    while !done
        if idle
            if nat[2] == prevnaty
                result = prevnaty
                done = true
            end
            push!(packetqueue[1], nat[1])
            push!(packetqueue[1], nat[2])
            prevnaty = nat[2]
        end
        idle = true
        for i in 1 : length(programs)
            inp = if length(packetqueue[i]) > 0
                packetqueue[i]
            else
                [-1]
            end
            out = runprogn(i, inp)
            if length(out) > 0
                idle = false
                for (ad, x, y) in eachcol(reshape(out, 3, length(out) ÷ 3))
                    if ad == 255
                        nat .= x, y
                    else
                        push!(packetqueue[ad + 1], x)
                        push!(packetqueue[ad + 1], y)
                    end
                end
            end
        end
    end
    
    result
end
