
function iskrampus(n)
    i = 10
    n2 = n^2
    while (a = n2 ÷ i) != 0
        if a + (b = n2 % i) == n && a != 0 && b != 0
            return n
        end
        i *= 10
    end
    0
end

function iskrampus2(n)
    i = 10
    while n^2 ÷ i != 0
        if n^2 ÷ i + n^2 % i == n && n^2 ÷ i != 0 && n^2 % i != 0
            return n
        end
        i *= 10
    end
    0
end


function main()
    open(
        io->mapreduce(x->iskrampus2(parse(Int, x)), +, eachline(io)),
        "krampus.txt", "r"
    )
end


function main2()
    open("krampus.txt", "r") do io
        s = 0
        for l in eachline(io)
            s += iskrampus(parse(Int, l))
        end
        s
    end
end
