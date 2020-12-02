

function expandareas!(board)
    h, w = size(board)
    
    changes = Tuple{Tuple{Int, Int}, Int}[]
    
    for i in 1 : h
        for j in 1 : w
            if board[i, j] == 0
                adjacents = [
                    i > 1 ? board[i - 1, j] : 0,
                    i < h ? board[i + 1, j] : 0,
                    j > 1 ? board[i, j - 1] : 0,
                    j < w ? board[i, j + 1] : 0
                ]
                
                a = 0
                for ad in adjacents
                    if ad != 0
                        if a == 0
                            a = ad
                        elseif ad != a
                            a = -1
                            break
                        end
                    end
                end
                if a != 0
                    push!(changes, ((i, j), a))
                end
            end
        end
    end
    
    for ((i, j), a) in changes
        board[i, j] = a
    end
    
    length(changes) > 0
end


function part1()
    coords = open("input.txt") do io
        [
            parse.(Int, split(l, ','))
            for l in eachline(io)
        ]
    end
    
    mx = minimum(x->x[1], coords)
    my = minimum(x->x[2], coords)
    
    offset = [mx - 1, my - 1]
    
    for c in coords
        c .-= offset
    end
    
    w = maximum(x->x[1], coords)
    h = maximum(x->x[2], coords)
    
    board = zeros(Int, h, w)
    
    for i in 1 : length(coords)
        board[reverse(coords[i])...] = i
    end
    
    while expandareas!(board) end
    
    dontcheck = Set{Int}()
    
    for i in 1 : w
        push!(dontcheck, board[1, i])
        push!(dontcheck, board[end, i])
    end
    
    for i in 1 : h
        push!(dontcheck, board[i, 1])
        push!(dontcheck, board[i, end])
    end
    
    check = setdiff(Set(1 : length(coords)), dontcheck)
    
    most = 0
    best = 0
    
    for c in check
        n = count(x->x==c, board)
        if n > most
            most = n
            best = c
        end
    end
    
    most, best
end


mandist(a, b) = abs(a[1] - b[1]) + abs(a[2] - b[2])


function part2()
    coords = open("input.txt") do io
        [
            parse.(Int, split(l, ','))
            for l in eachline(io)
        ]
    end
    
    thresh = 10000
    
    mx = minimum(x->x[1], coords)
    my = minimum(x->x[2], coords)
    
    offset = [mx - 1, my - 1]
    
    for c in coords
        c .-= offset
    end
    
    w = maximum(x->x[1], coords)
    h = maximum(x->x[2], coords)
    
    c = 0
    
    for i in 1 : h
        for j in 1 : w
            if sum(mandist((j, i), p) for p in coords) < thresh
                c += 1
            end
        end
    end
    
    c
end
