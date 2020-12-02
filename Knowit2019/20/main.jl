using Primes


function main()
    elves = zeros(Int, 5)
    
    readelf(n) = elves[((m = n % 5) < 0 ? m + 5 : m) + 1]
    incelf(n) = elves[((m = n % 5) < 0 ? m + 5 : m) + 1] += 1
    
    current_elf = 0
    dir = 1
    
    incelf(current_elf)
    
    for i in 2 : 1_000_740
        if isprime(i) && count(x->x==min(elves...), elves) == 1
            current_elf = indexin(min(elves...), elves)[] - 1
        elseif i % 28 == 0
            dir *= -1
            current_elf += dir
        elseif iseven(i) && count(x->x==max(elves...), elves) == 1 &&
            readelf(current_elf + dir) == max(elves...)
            current_elf += 2 * dir
        elseif i % 7 == 0
            current_elf = 4
        else
            current_elf += dir
        end
        
        incelf(current_elf)
    end
    
    max(elves...) - min(elves...)
end

