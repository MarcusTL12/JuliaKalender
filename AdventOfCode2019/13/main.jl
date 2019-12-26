include("../intcode.jl")

using DynamicTerminal

function makegameboard(out)
    amt_tiles = length(out) ÷ 3
    
    out = reshape(out, 3, amt_tiles)
    
    tiles = Dict{Tuple{Int, Int}, Int}()
    
    for i in 1 : amt_tiles
        tiles[out[1 : 2, i]...] = out[3, i]
    end
    
    w = h = 0
    
    for (x, y) in keys(tiles)
        (x > w) && (w = x)
        (y > h) && (h = y)
    end
    
    w += 1
    h += 1
    
    board = zeros(Int, h, w)
    
    score = 0
    ball = 0
    paddle = 0
    
    for ((x, y), v) in tiles
        if x == -1
            score = v
        else
            board[y + 1, x + 1] = v
            if v == 4
                ball = x + 1
            elseif v == 3
                paddle = x + 1
            end
        end
    end
    
    board, score, ball, paddle
end


function drawgameboard(board, score, io=stdout)
    h, w = size(board)
    
    # symbols = (
    #     ' ',
    #     '█',
    #     '░',
    #     '━',
    #     '●'
    # )
    
    symbols = (
        "  ",
        "██",
        "░░",
        "━━",
        "⚽ "
    )
    
    buff = IOBuffer()
    
    println(buff, "Score: ", score, "                       ")
    
    for i in 1 : h
        for j in 1 : w
            print(buff, symbols[board[i, j] + 1])
        end
        println(buff, "       ")
    end
    
    write(io, take!(buff))
end


function updateboard!(board, out)
    amt_tiles = length(out) ÷ 3
    
    out = reshape(out, 3, amt_tiles)
    
    score = 0
    ball = 0
    
    for i in 1 : amt_tiles
        (x, y) = out[1 : 2, i]
        
        if x == -1
            score = out[3, i]
        else
            board[y + 1, x + 1] = out[3, i]
            if out[3, i] == 4
                ball = x + 1
            end
        end
    end
    
    score, ball
end


function part1()
    program = loadprogram("input.txt")
    
    out, _, _ = runintcode(program)
    
    amt_tiles = length(out) ÷ 3
    
    out = reshape(out, 3, amt_tiles)
    
    tiles = Dict{Tuple{Int, Int}, Int}()
    
    for i in 1 : amt_tiles
        tiles[out[1 : 2, i]...] = out[3, i]
    end
    
    count(x->x==2, values(tiles))
end


function part1()
    program = loadprogram("input.txt")
    
    out, _, _ = runintcode(program)
    
    amt_tiles = length(out) ÷ 3
    
    out = reshape(out, 3, amt_tiles)
    
    tiles = Dict{Tuple{Int, Int}, Int}()
    
    for i in 1 : amt_tiles
        tiles[out[1 : 2, i]...] = out[3, i]
    end
    
    count(x->x==2, values(tiles))
end


function part2()
    program = loadprogram("input.txt")
    
    program[1] = 2
    
    out, done, state = runintcode!(program)
    
    board, score, ball, paddle = makegameboard(out)
    balldir = 1
    
    h, w = size(board)
    
    buff = IOBuffer()
    
    cursor(false)
    
    s = syncer(0.01)
    t = 0
    
    while !done
        if ball + balldir > paddle + 1
            inp = 1
        elseif ball + balldir < paddle - 1
            inp = -1
        else
            inp = 0
        end
        
        paddle += inp
        
        out, done, state = runintcode!(program, [inp], state)
        
        nscore, nball = updateboard!(board, out)
        
        nscore != 0 && (score = nscore)
        
        balldir = sign(nball - ball)
        ball = nball
        
        
        drawgameboard(board, score, buff)
        
        t = s()
        
        showandreset(buff)
    end
    
    cursor(true)
    
    score
end
