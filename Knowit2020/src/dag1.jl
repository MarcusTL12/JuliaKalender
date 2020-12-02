
function main()
    open("inputfiles/dag1.txt") do io
        setdiff(1 : 100000, parse.(Int, split(first(eachline(io)), ',')))
    end
end
