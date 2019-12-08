using Permutations

function runintcode!(program, input::Vector{Int}, pc=1)
    output = Int[]
    
    leave = false
    
    function addmul()
        instruction = program[pc]
        
        f = instruction % 100 == 1 ? (+) : (*)
        
        imm_a = (instruction ÷ 100)  % 10 == 1
        imm_b = (instruction ÷ 1000) % 10 == 1
        
        val_a = imm_a ? program[pc + 1] : program[program[pc + 1] + 1]
        val_b = imm_b ? program[pc + 2] : program[program[pc + 2] + 1]
        storeloc = program[pc + 3] + 1
        
        program[storeloc] = f(val_a, val_b)
        
        pc += 4
    end
    
    function inp()
        loc = program[pc + 1] + 1
        
        if length(input) > 0
            program[loc] = popfirst!(input)
        else
            leave = true
            return
        end
        
        pc += 2
    end
    
    function outp()
        instruction = program[pc]
        
        imm = (instruction ÷ 100) % 10 == 1
        
        val = imm ? program[pc + 1] : program[program[pc + 1] + 1]
        
        push!(output, val)
        
        pc += 2
    end
    
    function jmp()
        instruction = program[pc]
        
        f = instruction % 100 != 5
        
        imm_a = (instruction ÷ 100)  % 10 == 1
        imm_b = (instruction ÷ 1000) % 10 == 1
        
        val_a = imm_a ? program[pc + 1] : program[program[pc + 1] + 1]
        val_b = imm_b ? program[pc + 2] : program[program[pc + 2] + 1]
        
        if f ⊻ (val_a != 0)
            pc = val_b + 1
        else
            pc += 3
        end
    end
    
    function leq()
        instruction = program[pc]
        
        f = instruction % 100 == 7 ? (<) : (==)
        
        imm_a = (instruction ÷ 100)  % 10 == 1
        imm_b = (instruction ÷ 1000) % 10 == 1
        
        val_a = imm_a ? program[pc + 1] : program[program[pc + 1] + 1]
        val_b = imm_b ? program[pc + 2] : program[program[pc + 2] + 1]
        
        program[program[pc + 3] + 1] = f(val_a, val_b) ? 1 : 0
        
        pc += 4
    end
    
    optable = [
        addmul,
        addmul,
        inp,
        outp,
        jmp,
        jmp,
        leq,
        leq
    ]
    
    while !leave
        instruction = program[pc] % 100
        if instruction == 99
            break
        end
        
        optable[instruction]()
    end
    
    output, !leave, pc
end

runintcode(program, input::Vector{Int}) = runintcode!(copy(program), input)

function testsequence(program, seq)
    signal = 0
    for i in seq
        signal = runintcode(program, [i, signal])[1][1]
    end
    signal
end


function part1()
    program = open("input.txt", "r") do io
        parse.(Int, split(String(read(io)), ','))
    end
    
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
    program = open("input.txt", "r") do io
        parse.(Int, split(String(read(io)), ','))
    end
    
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
