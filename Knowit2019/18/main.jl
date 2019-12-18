

function genfirstname(name, firstnames)
    i = mapreduce(Int, +, Vector{Char}(name))
    firstnames[i % length(firstnames) + 1]
end


function genlastname(name, lastname1, lastname2, l=1)
    i1 = sum(
        Int.(Vector{Char}(lowercase(name))[1 : cld(length(name), 2)]) .- 96
    ) % length(lastname1) + 1
    
    i2 = prod(Int.(Vector{Char}(name))[cld(length(name), 2) + 1 : end]) * l
    i2s = string(i2) |> Vector{Char} |> sort! |> reverse! |> String
    i2 = parse(Int, i2s) % length(lastname2) + 1
    
    lastname1[i1] * lastname2[i2]
end


function genname(firstname, lastname, firstnames, lastname1, lastname2, man)
    genfirstname(firstname, firstnames) * " " *
    genlastname(
        lastname, lastname1, lastname2,
        man ? length(firstname) : length(firstname) + length(lastname)
    )
end


function main()
    men, women, lastname1, lastname2 = open("names.txt") do io
        split.(split(String(read(io)), "\n---\n"), '\n')
    end
    
    firstname = Dict([
        "M" => men,
        "F" => women
    ])
    
    namefreq = Dict{String, Int}()
    
    open("employees.csv") do io
        for m in eachmatch(r"(\w+),(\w+),([M,F])", String(read(io)))
            fn, ln, g = m.captures
            swname = genname(
                fn, ln, firstname[g], lastname1, lastname2, g == "M"
            )
            if !haskey(namefreq, swname)
                namefreq[swname] = 1
            else
                namefreq[swname] += 1
            end
        end
    end
    
    bestname = ""
    freq = 0
    
    for (n, f) in namefreq
        if f > freq
            freq = f
            bestname = n
        end
    end
    
    bestname
end
