
include("../intcode.jl")


function part1()
    program = loadprogram("input.txt")
    
    instructions = """
    NOT T T
    AND A T
    AND B T
    AND C T
    NOT T J
    AND D J
    WALK
    """
    
    out, _, _ = runintcode(program, Int.(Vector{Char}(instructions)))
    
    println(String(Char.(out[1 : end - 1])))
    
    out[end]
end


function part2()
    program = loadprogram("input.txt")
    
    instructions = """
    NOT T T
    AND A T
    AND B T
    AND C T
    NOT T J
    AND D J
    NOT J T
    NOT T T
    AND E T
    OR H T
    AND T J
    RUN
    """
    
    out, _, _ = runintcode(program, Int.(Vector{Char}(instructions)))
    
    # println(String(Char.(out[1:end - 1])))
    
    out[end]
end

