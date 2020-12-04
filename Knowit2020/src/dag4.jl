

function main()
    ingredients = Dict(["sukker" => 0, "melk" => 0, "mel" => 0, "egg" => 0])
    open("inputfiles/dag4/leveringsliste.txt") do io
        for l in eachline(io)
            for part in split(l, ", ")
                (ing, amt) = split(part, ": ")
                ingredients[ing] += parse(Int, amt)
            end
        end
    end
    
    ingredients["sukker"] ÷= 2
    ingredients["mel"] ÷= 3
    ingredients["melk"] ÷= 3
    
    minimum(values(ingredients))
end
