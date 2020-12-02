
include("../intcode.jl")


function part1()
    program = loadprogram("input.txt")
    
    function pulled((x, y))
        runintcode(program, [x, y])[1][] == 1
    end
    
    pulled.((x, y) for x in 0 : 49, y in 0 : 49) |> count
end


function renderbeam(beam)
    h, w = size(beam)
    
    for i in 1 : h
        for j in 1 : w
            print(beam[i, j] ? '░' : '.')
        end
        println()
    end
end


function part2()
    program = loadprogram("input.txt")
    
    function pulled((x, y))
        runintcode(program, [x, y])[1][] != 0
    end
    
    pulled(x, y) = pulled((x, y))
    
    function widestat(n)
        y = n
        x = 0
        while !pulled(x, y)
            x += 1
        end
        
        i = 1
        
        while pulled(x + i, y - i)
            i += 1
        end
        
        i, x
    end
    
    low = 8
    high = 16
    
    while widestat(high)[1] < 100
        low = high
        high *= 2
    end
    
    while low < high
        mid = fld(low + high, 2)
        if widestat(mid)[1] < 100
            low = mid + 1
        else
            high = mid
        end
    end
    
    x = widestat(low)[2]
    y = low
    x * 10000 + low - 99
end
