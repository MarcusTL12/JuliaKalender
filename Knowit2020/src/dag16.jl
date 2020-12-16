using Base.Iterators
using Primes


function sum_of_divisors(n)
    facs = factor(n)
    sum(prod(facs.pe[i].first^n for (i, n) in enumerate(exps))
    for exps in product((0:n for (_, n) in facs)...))
end


function is_square(n)
    all(iseven(x) for (_, x) in factor(n))
end


function main()
    count(is_square, (s - 2n
    for (n, s) in ((n, sum_of_divisors(n)) for n in 2:1000_000) if s > 2n))
end
