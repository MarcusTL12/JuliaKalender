
function part1()
    open("input.txt", "r") do io
        sum(parse(Int, i) ÷ 3 - 2 for i in eachline(io))
    end
end

function modfuel(mass)
    fuel = mass ÷ 3 - 2
    if fuel <= 0
        0
    else
        fuel + modfuel(fuel)
    end
end

function part2()
    open("input.txt", "r") do io
        sum(modfuel(parse(Int, i)) for i in eachline(io))
    end
end
