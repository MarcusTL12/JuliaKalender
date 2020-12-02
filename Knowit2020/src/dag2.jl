using Primes


function main()
    n = 5433000
    k = 0
    i = 0
    while i < n
        if 7 in digits(i)
            i += prevprime(i)
        else
            k += 1
        end
        
        
        i += 1
    end
    
    k
end
