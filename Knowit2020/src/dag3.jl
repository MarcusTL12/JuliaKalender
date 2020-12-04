
# ordbok = [
#     "kakao",
#     "kriminalroman",
#     "kvikklunch",
#     "kylling",
#     "langfredag",
#     "langrennski",
#     "palmesøndag",
#     "påskeegg",
#     "smågodt",
#     "solvegg",
#     "yatzy",
# ]

using Base: transpose
Base.transpose(x::Char) = x

function main()
    mat = open("inputfiles/dag3/matrix.txt") do io
        m = Char[]
        for l in eachline(io)
            append!(m, l)
        end
        w = Int(√(length(m)))
        reshape(m, (w, w))
    end
    
    ordbok = open("inputfiles/dag3/wordlist.txt") do io
        collect(eachline(io))
    end
    
    w = size(mat)[1]
    
    words = String[]
    
    function leggtilord(s)
        for ord in ordbok
            if occursin(ord, s)
                push!(words, ord)
            end
        end
    end
    
    s = String(mat[:])
    leggtilord(s)
    s = reverse(s)
    leggtilord(s)
    s = String(transpose(mat)[:])
    leggtilord(s)
    s = reverse(s)
    leggtilord(s)
    for i in 1 : w
        s = String([mat[i + j - 1, j] for j in 1 : w - i + 1])
        leggtilord(s)
        s = reverse(s)
        leggtilord(s)
        s = String([mat[j, i + j - 1] for j in 1 : w - i + 1])
        leggtilord(s)
        s = reverse(s)
        leggtilord(s)
    end
    mat = rotl90(mat)
    for i in 1 : w
        s = String([mat[i + j - 1, j] for j in 1 : w - i + 1])
        leggtilord(s)
        s = reverse(s)
        leggtilord(s)
        s = String([mat[j, i + j - 1] for j in 1 : w - i + 1])
        leggtilord(s)
        s = reverse(s)
        leggtilord(s)
    end
    a = setdiff(ordbok, words)
    sort!(a)
    for s in a
        print(s, ",")
    end
    println()
end
