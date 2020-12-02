

function countlines()
    lc = 0
    for (r, d, f) in walkdir(".")
        for filename in f
            if filename == "main.jl"
                open(joinpath(r, filename)) do io
                    for l in eachline(io)
                        if length(l) > 0
                            lc += Int(!mapreduce(isspace, (a, b)->a&&b, l))
                        end
                    end
                end
            end
        end
    end
    lc
end
