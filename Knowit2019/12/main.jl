

function dothing(n)
    if n in 0 : 1111 : 9999
        return 6174
    end
    c = sort!(Vector{Char}(string(n)))
    
    if length(c) < 4
        append!(c, ('0' for _ in 1 : 4 - length(c)))
    end
    
    abs(parse(Int, String(reverse(c))) - parse(Int, String(c)))
end


function dountil6174(n)
    i = 0
    while n != 6174
        n = dothing(n)
        i += 1
    end
    i
end


function main()
    count(x->x==7, dountil6174.(1000 : 9999))
end
