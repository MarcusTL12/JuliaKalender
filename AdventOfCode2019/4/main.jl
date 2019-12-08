

function isvalidpassword(pass)
    repeat = false
    decrease = false
    prevdigit = -1
    
    for c in Vector{Char}(string(pass))
        i = parse(Int, c)
        if i == prevdigit
            repeat = true
        end
        
        if i < prevdigit
            decrease = true
        end
        
        prevdigit = i
    end
    
    repeat && !decrease
end


function isvalidpassword2(pass)
    repeat = false
    amtrepeat = 0
    decrease = false
    prevdigit = -1
    
    for c in Vector{Char}(string(pass))
        i = parse(Int, c)
        if i == prevdigit
            amtrepeat += 1
        else
            if amtrepeat == 1
                repeat = true
            end
            amtrepeat = 0
        end
        
        if i < prevdigit
            decrease = true
        end
        
        prevdigit = i
    end
    
    if amtrepeat == 1
        repeat = true
    end
    
    repeat && !decrease
end


function main()
    amt = 0
    
    for i in 359282 : 820401
        if isvalidpassword2(i)
            amt += 1
        end
    end
    
    amt
end
