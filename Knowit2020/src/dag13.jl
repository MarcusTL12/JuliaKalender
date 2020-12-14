

function main()
    s = open(Vector{Char} ∘ String ∘ read, "inputfiles/dag13/text.txt")
    for c in "abcdefghijklmnopqrstuvwxyz"
        found_c = 0
        ns = sizehint!(Char[], length(s))
        for x in s
            if x == c
                found_c += 1
                if found_c != Int(x - 'a' + 1)
                    continue
                end
            end
            push!(ns, x)
        end
        s = ns
    end
    String(s)
end
