

function is_palinestendrome(s)
    s = Vector{Char}(s)
    if length(s) == 2
        return false
    end
    i = 1
    while i < cld(length(s), 2)
        if s[i] == s[end + 1 - i]
            i += 1
        elseif length(s) - 2i > 1 &&
            (s[i], s[i + 1]) == (s[end - i], s[end + 1 - i])
            i += 2
        else
            return false
        end
    end
    true
end


function main()
    open("inputfiles/dag18/wordlist.txt") do io
        count(l != reverse(l) && is_palinestendrome(l) for l in eachline(io))
    end
end
