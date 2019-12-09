
function iscrampit(n)
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


function main()
    open(
        io->mapreduce(x->iscrampit(parse(Int, x)), +, eachline(io)),
        "krampus.txt", "r"
    )
end
