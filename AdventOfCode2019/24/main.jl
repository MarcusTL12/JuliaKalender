

function renderboard(board)
    h, w = size(board)
    
    for i in 1 : h
        for j in 1 : w
            print(board[i, j] ? '#' : '.')
        end
        println()
    end
end


function loadboard(filename)
    open(filename) do io
        hcat([Vector{Char}(l) .== '#' for l in eachline(io)]...) |>
        transpose |> copy
    end
end


function part1()
    board = loadboard("input.txt")
    
    h, w = size(board)
    
    buffer = falses(h, w)
    
    function alivenext(i, j)
        c = count([
            i > 1 && board[i - 1, j],
            i < h && board[i + 1, j],
            j > 1 && board[i, j - 1],
            j < w && board[i, j + 1]
        ])
        
        if board[i, j]
            c == 1
        else
            1 <= c <= 2
        end
    end
    
    seenbefore = Set([copy(board)])
    
    done = false
    
    i = 0
    
    while !done
        buffer .= (alivenext(i, j) for i in 1 : h, j in 1 : w)
        
        i += 1
        
        temp = buffer
        buffer = board
        board = temp
        
        if board in seenbefore
            # renderboard(board)
            done = true
        else
            push!(seenbefore, copy(board))
        end
    end
    
    biod = 0
    d = 1
    for i in 1 : h, j in 1 : w
        if board[i, j]
            biod += d
        end
        d <<= 1
    end
    
    biod
end


function part2()
    h = 201
    
    board = falses(5, 5, h)
    buffer = copy(board)
    mid = (h + 1) ÷ 2
    
    board[:, :, mid] .= loadboard("input.txt")
    
    function countadj(i, j, k)
        if !(i == j == 3)
            c = 0
            
            c += if i == 1
                Int(k > 1 && board[2, 3, k - 1])
            elseif i == 4 && j == 3
                k < h ? count(board[5, :, k + 1]) : 0
            else
                Int(board[i - 1, j, k])
            end
            
            c += if i == 5
                Int(k > 1 && board[4, 3, k - 1])
            elseif i == 2 && j == 3
                k < h ? count(board[1, :, k + 1]) : 0
            else
                Int(board[i + 1, j, k])
            end
            
            c += if j == 1
                Int(k > 1 && board[3, 2, k - 1])
            elseif i == 3 && j == 4
                k < h ? count(board[:, 5, k + 1]) : 0
            else
                Int(board[i, j - 1, k])
            end
            
            c += if j == 5
                Int(k > 1 && board[3, 4, k - 1])
            elseif i == 3 && j == 2
                k < h ? count(board[:, 1, k + 1]) : 0
            else
                Int(board[i, j + 1, k])
            end
            
            c
        else
            0
        end
    end
    
    function alivenext(i, j, k)
        if i == j == 3
            return false
        end
        
        c = countadj(i, j, k)
        
        if board[i, j, k]
            c == 1
        else
            1 <= c <= 2
        end
    end
    
    for _ in 1 : 200
        buffer .= (alivenext(i, j, k) for i in 1 : 5, j in 1 : 5, k in 1 : h)
        temp = buffer
        buffer = board
        board = temp
    end
    
    count(board)
end
