

function main()
    open("inputfiles/dag10/leker.txt") do io
        points = Dict{String,Int}()
        for l in eachline(io)
            ranks = split(l, ',')
            for (i, elf) in enumerate(ranks)
                if !haskey(points, elf)
                    points[elf] = 0
                end
                points[elf] += length(ranks) - i
            end
        end
        points
        max_score = maximum(values(points))
        best_elf =
        first(elf for elf in keys(points) if points[elf] == max_score)
        "$best_elf-$max_score"
    end
end
