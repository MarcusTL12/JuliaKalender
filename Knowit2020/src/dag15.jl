
function main()
    ordbok = open(Set ∘ eachline, "inputfiles/dag15/wordlist.txt")
    
    function is_glue_word(a, b, word)
        a * word in ordbok && word * b in ordbok
    end
    
    gluewords = Set{String}()
    
    open("inputfiles/dag15/riddles.txt") do io
        for l in eachline(io)
            a, b = split(l, ", ")
            for ord in ordbok
                if is_glue_word(a, b, ord)
                    push!(gluewords, ord)
                end
            end
        end
    end
    
    # sum(length, gluewords)
    sum(length ∘ Vector{UInt8}, gluewords)
end
