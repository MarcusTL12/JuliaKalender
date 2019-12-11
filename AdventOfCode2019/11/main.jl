
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
        
        # @show program (instruction, pc, relbase) output
        
        optable[instruction]()
    end
    
    output, !leave, (pc, relbase)
end

runintcode(program, input::Vector{Int}=Int[]) =
runintcode!(copy(program), input)


function part1()
    program = open(io->parse.(Int, split(String(read(io)), ',')), "input.txt")
    
    hull = Dict{Complex{Int}, Int}()
    
    getpaint(pos) = haskey(hull, pos) ? hull[pos] : 0
    
    curpos = 0 + 0im
    dir = 1im
    
    
    (col, dir_change), done, pc = runintcode!(program, [0])
    
    while !done
        hull[curpos] = col
        dir *= ((dir_change * (-2) + 1) * 1im)
        curpos += dir
        
        (col, dir_change), done, pc =
        runintcode!(program, [getpaint(curpos)], pc)
    end
    
    length(keys(hull))
end


function part2()
    program = open(io->parse.(Int, split(String(read(io)), ',')), "input.txt")
    
    hull = Dict{Complex{Int}, Int}()
    
    getpaint(pos) = haskey(hull, pos) ? hull[pos] : 0
    
    curpos = 0 + 0im
    dir = 1im
    
    
    (col, dir_change), done, pc = runintcode!(program, [1])
    
    while !done
        hull[curpos] = col
        dir *= ((dir_change * (-2) + 1) * 1im)
        curpos += dir
        
        p = getpaint(curpos)
        
        (col, dir_change), done, pc =
        runintcode!(program, [p], pc)
    end
    
    upperleft = [0, 0]
    lowerright = [0, 0]
    
    for k in keys(hull)
        if real(k) < upperleft[1]
            upperleft[1] = real(k)
        end
        if -imag(k) < upperleft[2]
            upperleft[2] = -imag(k)
        end
        if real(k) > lowerright[1]
            lowerright[1] = real(k)
        end
        if -imag(k) > lowerright[2]
            lowerright[2] = -imag(k)
        end
    end
    
    out = zeros(Int,
        lowerright[2] - upperleft[2] + 1, lowerright[1] - upperleft[1] + 1
    )
    
    for k in keys(hull)
        out[-imag(k) + 1, real(k) + 1] = hull[k]
    end
    
    out = [i == 0 ? ' ' : '█' for i in out]
    
    println.(String(out[i, :]) for i in 1 : size(out)[1])
    nothing
end
