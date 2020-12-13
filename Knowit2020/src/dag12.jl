
reg = r"(\(?)\w+(\)*)"

function main()
    generasjon = 1
    alver = Int[0]
    for m in eachmatch(reg, open(String ∘ read, "inputfiles/dag12/family.txt"))
        if m.captures[1] == "("
            generasjon += 1
            if length(alver) < generasjon
                push!(alver, 0)
            end
        end
        
        alver[generasjon] += 1
        
        generasjon -= length(m.captures[2])
    end
    maximum(alver)
end
