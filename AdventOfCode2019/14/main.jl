

function loadrecipie(filename)
    open(filename) do io
        function parseline(l)
            inp, out = split(l, "=>")
            
            inp = [
                (
                    s = split(i);
                    (parse(Int, s[1]), s[2])
                )
                for i in split(inp, ',')
            ]
            
            out = (
                s = split(out);
                (parse(Int, s[1]), s[2])
            )
            
            out[2] => (out[1], inp)
        end
        
        Dict{
            String, Tuple{Int, Vector{Tuple{Int, String}}}
        }(parseline.(eachline(io)))
    end
end


function makefuel(recipies, n)
    curprod = Dict(keys(recipies) .=> 0)
    cursurplus = Dict(keys(recipies) .=> 0)
    push!(curprod, "ORE" => 0)
    push!(cursurplus, "ORE" => 0)
    
    function make(chemical, n)
        if chemical == "ORE"
            curprod["ORE"] += n
        else
            recipie = recipies[chemical]
            amtrecipies = cld(n, recipie[1])
            cursurplus[chemical] += amtrecipies * recipie[1] - n
            curprod[chemical] += amtrecipies * recipie[1]
            
            for (amt, inp_chem) in recipie[2]
                need = amt * amtrecipies
                if need < cursurplus[inp_chem]
                    cursurplus[inp_chem] -= need
                else
                    need -= cursurplus[inp_chem]
                    cursurplus[inp_chem] = 0
                    make(inp_chem, need)
                end
            end
        end
    end
    
    make("FUEL", n)
    
    curprod["ORE"]
end


function part1()
    recipies = loadrecipie("input.txt")
    
    makefuel(recipies, 1)
end


function part2()
    recipies = loadrecipie("input.txt")
    
    availableore = 1000000000000
    
    low = 1
    high = 2
    
    while makefuel(recipies, high) < availableore
        low *= 2
        high *= 2
    end
    
    while high - low > 1
        mid = fld(high + low, 2)
        ore = makefuel(recipies, mid)
        if ore > availableore
            high = mid
        elseif ore < availableore
            low = mid
        else
            return mid
        end
    end
    
    low
end
