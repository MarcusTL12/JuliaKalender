using Primes


function crosssum(n)
    acc = 0
    while n > 0
        acc += n % 10
        n ÷= 10
    end
    acc
end


function main()
    rel_primes = Set(primes(71))
    count(n -> ((s = crosssum(n)) in rel_primes) && n % s == 0, 1 : 98765432)
end


oneline() =
count(n -> ((s = sum(digits(n))) |> isprime) && n % s == 0, 1 : 98765432)
