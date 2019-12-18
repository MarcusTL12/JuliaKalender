
include("../intcode.jl")


function part1()
    program = loadprogram("input.txt")
    out, _, _ = runintcode!(program, Int[1])
    out
end


function part2()
    program = loadprogram("input.txt")
    out, _, _ = runintcode!(program, Int[2])
    out
end
