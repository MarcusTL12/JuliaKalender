

# function run((a, b))
#     p = copy(program)
#     p[2] = a
#     p[3] = b
#     # program = [1,9,10,3,2,3,11,0,99,30,40,50]
    
#     pc = 1
    
#     while true
#         if p[pc] == 99
#             break
#         end
#         f = (p[pc] == 1) ? (+) : (*)
#         p[p[pc + 3] + 1] = f(
#             p[p[pc + 1] + 1], p[p[pc + 2] + 1]
#         )
#         pc += 4
#     end
#     p[1]
# end

function runintcode(program)
    program = copy(program)
    
    pc = 1
    
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
        
        program[loc] = parse(Int, readline())
        
        pc += 2
    end
    
    function outp()
        instruction = program[pc]
        
        imm = (instruction ÷ 100)  % 10 == 1
        
        val = imm ? program[pc + 1] : program[program[pc + 1] + 1]
        
        println(val)
        
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
        
        imm_a = (instruction ÷ 100)   % 10 == 1
        imm_b = (instruction ÷ 1000)  % 10 == 1
        
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
    
    amtins = 0
    
    while true
        instruction = program[pc] % 100
        if instruction == 99
            break
        end
        
        optable[instruction]()
        
        amtins += 1
    end
    
    @show amtins
    
    program
end


function main()
    program = open("input.txt", "r") do io
        parse.(Int, split(String(read(io)), ','))
    end
    
    runintcode(program)
    nothing
end
