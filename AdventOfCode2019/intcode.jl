function runintcode!(program, input::Vector{Int}=Int[], (pc, relbase)=(0, 0))
    output = Int[]
    
    leave = false
    
    function regrow(nsize)
        howmuch = nsize - length(program)
        append!(program, (0 for _ in 1 : howmuch))
    end
    
    function getmem(ind)
        if ind + 1 > length(program)
            regrow(ind + 1)
        end
        program[ind + 1]
    end
    
    function setmem(ind, val)
        if ind + 1 > length(program)
            regrow(ind + 1)
        end
        program[ind + 1] = val
    end
    
    function getval(ind)
        ins = getmem(pc)
        val = getmem(pc + ind)
        code = (ins ÷ 10^(ind + 1)) % 10
        if code == 1
            val
        elseif code == 0
            return getmem(val)
        elseif code == 2
            return getmem(relbase + val)
        else
            -1
        end
    end
    
    function setval(ind, val)
        ins = getmem(pc)
        code = (ins ÷ 10^(ind + 1)) % 10
        if code == 0
            setmem(getmem(pc + ind), val)
        elseif code == 2
            setmem(getmem(pc + ind) + relbase, val)
        end
    end
    
    function addmul()
        instruction = getmem(pc)
        
        f = instruction % 100 == 1 ? (+) : (*)
        
        setval(3, f(getval(1), getval(2)))
        
        pc += 4
    end
    
    function inp()
        if length(input) > 0
            setval(1, popfirst!(input))
        else
            leave = true
            return
        end
        
        pc += 2
    end
    
    function outp()
        push!(output, getval(1))
        
        pc += 2
    end
    
    function jmp()
        instruction = getmem(pc)
        
        f = instruction % 100 != 5
        
        if f ⊻ (getval(1) != 0)
            pc = getval(2)
        else
            pc += 3
        end
    end
    
    function leq()
        instruction = getmem(pc)
        
        f = instruction % 100 == 7 ? (<) : (==)
        
        setval(3, f(getval(1), getval(2)) ? 1 : 0)
        
        pc += 4
    end
    
    function setrelbase()
        relbase += getval(1)
        pc += 2
    end
    
    optable = [
        addmul,
        addmul,
        inp,
        outp,
        jmp,
        jmp,
        leq,
        leq,
        setrelbase
    ]
    
    while !leave
        instruction = getmem(pc) % 100
        if instruction == 99
            break
        end
        
        optable[instruction]()
    end
    
    output, !leave, (pc, relbase)
end

runintcode(program, input::Vector{Int}=Int[]) =
runintcode!(copy(program), input)

loadprogram(filename) = open(
    io->parse.(Int, split(String(read(io)), ',')), filename
)