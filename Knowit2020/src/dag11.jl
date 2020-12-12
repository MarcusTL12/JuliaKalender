using Mods

password = "eamqia"

function checkhint(hint)
    mat = zeros(Mod{26}, length(hint), length(hint))
    mat[1, :] .= (Int(c - 'a') for c in hint)
    for i in 2:length(hint)
        mat[i, 1:end - i + 1] .= @view mat[i - 1, 2:end - i + 2]
        mat[i, 1:end - i + 1] .+= 1
        mat[i, 1:end - i + 1] .+= mat[i - 1, 1:end - i + 1]
    end
    for i in 1:length(hint)
        if contains(String(['a' + x.val for x in @view mat[1:end - i + 1]]),
            password)
            return true
        end
    end
    false
end

function main()
    open("inputfiles/dag11/hint.txt") do io
        only(l for l in eachline(io) if checkhint(l))
    end
end
