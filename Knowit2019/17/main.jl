

function fromdigtis(d)
    sum(10^(i - 1) * d[i] for i in 1 : length(d))
end

function roll(n)
    d = digits(n)
    
    [fromdigtis(pushfirst!(d, pop!(d))) for _ in 1 : length(d)]
end

function isquadrollable(n)
    for m in roll(n)
        if (s = √m) - floor(s) == 0
            return true
        end
    end
    false
end

function trianglenumber(n)
    n * (n + 1) ÷ 2
end

function main()
    count(isquadrollable ∘ trianglenumber, 0 : 1_000_000 - 1)
end
