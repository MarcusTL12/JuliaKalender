using Permutations

include("../intcode.jl")

function testsequence(program, seq)
    signal = 0
    for i in seq
        signal = runintcode(program, [i, signal])[1][1]
    end
    signal
end


function part1()
    program = loadprogram("input.txt")
    
    best = 0
    
    @time for i in 1 : factorial(5)
        perm = Permutation(5, i)
        seq = Matrix(perm) * [0, 1, 2, 3, 4]
        new = testsequence(program, seq)
        if new > best
            best = new
        end
    end
    
    best
end


function testsequence2(program, seq)
    programs = [copy(program) for _ in seq]
    pcs = [1 for _ in seq]
    
    signal = 0
    
    for i in 1 : length(seq)
        signal_buff, _, pcs[i] = runintcode!(programs[i], [seq[i], signal])
        signal = signal_buff[1]
    end
    
    dones = [false for _ in seq]
    i = 1
    
    lastE = 0
    
    while !dones[i]
        signal_buff, dones[i], pcs[i] = runintcode!(programs[i], [signal], pcs[i])
        signal = signal_buff[1]
        i += 1
        if i > length(seq)
            i -= length(seq)
            lastE = signal
        end
    end
    
    lastE
end


function part2()
    program = loadprogram("input.txt")
    
    best = 0
    
    for i in 1 : factorial(5)
        perm = Permutation(5, i)
        seq = Matrix(perm) * [5, 6, 7, 8, 9]
        new = testsequence2(program, seq)
        if new > best
            best = new
        end
    end
    
    best
end
