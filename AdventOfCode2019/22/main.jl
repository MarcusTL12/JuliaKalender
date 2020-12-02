using AbstractAlgebra


function dealtonew!(s1, s2)
    for i in 1 : length(s1)
        s2[end - i + 1] = s1[i]
    end
end


function cutn!(s1, s2, n)
    for i in 1 : length(s1)
        s2[i] = s1[(i + n - 1 + (n < 0 ? length(s1) : 0)) % length(s1) + 1]
    end
end


function dealwithn!(s1, s2, n)
    for i in 1 : length(s1)
        s2[(i - 1) * n % length(s1) + 1] = s1[i]
    end
end


function part1()
    n = 10007
    deck1 = collect(0 : n - 1)
    deck2 = copy(deck1)
    
    open("input.txt") do io
        for l in eachline(io)
            if l == "deal into new stack"
                dealtonew!(deck1, deck2)
            elseif !((m = match(r"cut (-?\d+)", l)) |> isnothing)
                cutn!(deck1, deck2, parse(Int, m.captures[1]))
            elseif !((m = match(r"deal with increment (\d+)", l)) |> isnothing)
                dealwithn!(deck1, deck2, parse(Int, m.captures[1]))
            end
            temp = deck1
            deck1 = deck2
            deck2 = temp
        end
    end
    
    indexin(2019, deck1)[] - 1
end


function makepoly(filename, n)
    Zn = ResidueRing(ZZ, n)
    NPoly, x = PolynomialRing(Zn, "x")
    
    p1 = -x - 1
    p2(m) = x + m
    p3(m) = inv(Zn(m)) * x
    
    open(filename) do io
        p = x
        polys = typeof(x)[]
        for l in eachline(io)
            pt = if l == "deal into new stack"
                p1
            elseif !((m = match(r"cut (-?\d+)", l)) |> isnothing)
                p2(parse(Int, m.captures[1]))
            elseif !((m = match(r"deal with increment (\d+)", l)) |> isnothing)
                p3(parse(Int, m.captures[1]))
            end
            
            pushfirst!(polys, pt)
        end
        
        for pt in polys
            p = pt(p)
        end
        
        p
    end, NPoly
end


function polyiterate(p, n, p_ring)
    a = coeff(p, 1)
    b = coeff(p, 0)
    
    x = p_ring([0, 1])
    
    a^n * x + b * (1 - a^n) * inv(1 - a)
end


function part2()
    n1 = 119315717514047
    n2 = 101741582076661
    
    p, P = makepoly("input.txt", n1)
    
    pi = polyiterate(p, n2, P)
    
    pi(2020)
end

