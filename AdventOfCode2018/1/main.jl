
function part1()
    open(io->mapfoldl(s->parse(Int, s), +, eachline(io)), "input.txt")
end


function part2()
    nums = open(io->parse.(Int, eachline(io)), "input.txt")
    
    i = 1
    s = Set{Int}()
    f = 0
    
    while f ∉ s
        push!(s, f)
        f += nums[i]
        i += 1
        if i > length(nums)
            i = 1
        end
    end
    f
end
