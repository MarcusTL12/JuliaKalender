
const pattern = [0, 1, 0, -1]


function patternat(i, j)
    pattern[((fld(i, j)) % 4) + 1]
end


function part1()
    inp = open(String ∘ read, "input.txt")
    # inp = "12345678"
    # inp = "80871224585914546619083218645595"
    
    signal = parse.(Int, Vector{Char}(inp))
    signal2 = zeros(Int, length(signal))
    
    for _ in 1 : 100
        for i in 1 : length(signal)
            n = 0
            for j in 1 : length(signal)
                n += signal[j] * patternat(j, i)
            end
            signal2[i] = abs(n) % 10
        end
        signal .= signal2
    end
    
    mapreduce(string, *, signal2[1:8])
end


function part2()
    inp = open(String ∘ read, "input.txt")
    
    index = parse(Int, inp[1 : 7])
    
    signal = parse.(Int, Vector{Char}(inp))
    
    persignal(n) = signal[(n - 1) % length(signal) + 1]
    
    actualsignal = persignal.(index + 1 : 10000 * length(signal))
    
    for _ in 1 : 100
        for i in length(actualsignal) - 1 : -1 : 1
            actualsignal[i] += actualsignal[i + 1]
            actualsignal[i] %= 10
        end
    end
    
    mapreduce(string, *, actualsignal[1:8])
end
