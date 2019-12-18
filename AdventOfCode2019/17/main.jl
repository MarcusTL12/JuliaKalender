
include("../intcode.jl")


function tomatrix(out)
    mat = split(String(Char.(out)), '\n')[1:end-2]
    
    [
        Vector{Char}(mat[j])[i]
        for j in 1 : length(mat), i in 1 : length(mat[1])
    ]
end


function part1()
    program = loadprogram("input.txt")
    
    out, _, _ = runintcode!(program)
    
    mat = tomatrix(out)
    
    h, w = size(mat)
    
    acc = 0
    
    for i in 2 : h - 1
        for j in 2 : w - 1
            if mat[i, j] == '#' && mat[i - 1, j] == '#' &&
                mat[i + 1, j] == '#' && mat[i, j - 1] == '#' &&
                mat[i, j + 1] == '#'
                acc += (i - 1) * (j - 1)
            end
        end
    end
    
    
    acc
end


function findsubarrays(s, a)
    ret = UnitRange{Int}[]
    for i in 1 : length(a) - length(s) + 1
        if s == a[i : i + length(s) - 1]
            push!(ret, i : i + length(s) - 1)
        end
    end
    ret
end


function findmaximalcover(n, a)
    best = 0
    bestamt = 0
    
    for i in 1 : length(a) - n + 1
        if (l = length(findsubarrays(a[i : i + n - 1], a))) > bestamt
            bestamt = l
            best = i
        end
    end
    
    bestamt, a[best : best + n - 1]
end


function path2str(p)
    if length(p) == 1
        p[1]
    else
        p[1] * "," * path2str(p[2 : end])
    end
end


function part2prep()
    program = loadprogram("input.txt")
    out, _, _ = runintcode(program)
    
    board = tomatrix(out)
    
    h, w = size(board)
    
    getsym(c::Complex{Int}) = if (1 <= real(c) <= w) && (1 <= -imag(c) <= h)
        board[-imag(c), real(c)] != '.'
    else
        false
    end
    
    pos = Complex(indexin('^', board)[].I...) * -im
    dir = -1 + 0im
    
    path = ["L"]
    
    done = false
    
    while !done
        i = 0
        while getsym(pos + (i + 1) * dir)
            i += 1
        end
        
        if i > 0
            pos += i * dir
            push!(path, string(i))
        end
        
        if getsym(pos + dir * im)
            dir *= im
            push!(path, "L")
        elseif getsym(pos - dir * im)
            dir *= -im
            push!(path, "R")
        else
            done = true
        end
    end
    
    println(path2str(path))
end


function part2()
    program = loadprogram("input.txt")
    program[1] = 2
    
    instructions = """
    A,B,A,B,C,C,B,A,B,C
    L,4,R,8,L,6,L,10
    L,6,R,8,R,10,L,6,L,6
    L,4,L,4,L,10
    n
    """
    
    out, _, _ = runintcode!(program, Int.(instructions |> Vector{Char}))
    
    println(String(Char.(out)))
    out[end]
end
