using Primes

function main()
    seq = [0, 1]
    seq_set = Set(seq)
    while length(seq) < 1800813
        n = length(seq)
        x = seq[end - 1] - n
        if x < 0 || x in seq_set
            x = seq[end - 1] + n
        end
        push!(seq, x)
        push!(seq_set, x)
    end
    count(isprime, seq)
end
