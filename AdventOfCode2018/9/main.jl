

function part1()
    amtelves = 463
    lastmarble = 71787
    
    marbles = [0]
    
    curmarble = 1
    curelf = 1
    
    elfscores = zeros(Int, amtelves)
    
    for i in 1 : lastmarble
        if i % 23 != 0
            ncur = (curmarble == length(marbles) ? 0 : curmarble) + 2
            insert!(marbles, ncur, i)
            curmarble = ncur
            
        else
            r = curmarble - 7
            while r < 1
                r += length(marbles)
            end
            
            elfscores[curelf] += i + marbles[r]
            deleteat!(marbles, r)
            curmarble = r
            if curmarble > length(marbles)
                curmarble = 2
            end
        end
        
        curelf += 1
        if curelf > amtelves
            curelf = 1
        end
    end
    
    maximum(identity, elfscores)
end


function part2()
    amtelves = 463
    lastmarble = 7178700
    
    marbles = [0]
    
    curmarble = 1
    curelf = 1
    
    elfscores = zeros(Int, amtelves)
    
    for i in 1 : lastmarble
        if i % 23 != 0
            ncur = (curmarble == length(marbles) ? 0 : curmarble) + 2
            insert!(marbles, ncur, i)
            curmarble = ncur
            
        else
            r = curmarble - 7
            while r < 1
                r += length(marbles)
            end
            
            elfscores[curelf] += i + marbles[r]
            deleteat!(marbles, r)
            curmarble = r
            if curmarble > length(marbles)
                curmarble = 2
            end
        end
        
        curelf += 1
        if curelf > amtelves
            curelf = 1
        end
        
        if i % 100_000 == 0
            println(round(i / lastmarble * 100; digits = 1), "%")
        end
    end
    
    maximum(identity, elfscores)
end


function part2better()
    amtelves = 463
    lastmarble = 7178700
    
    marbles = [[0, 1, 1]]
    sizehint!(marbles, lastmarble)
    
    function deletemarble(m)
        marbles[m[2]][3] = m[3]
        marbles[m[3]][2] = m[2]
    end
    
    function insertmarble(m, v)
        prevpos = marbles[m[2]][3]
        nextpos = m[3]
        push!(marbles, [v, prevpos, nextpos])
        marbles[prevpos][3] = length(marbles)
        marbles[nextpos][2] = length(marbles)
    end
    
    function offsetmarble(m, n)
        j = n < 0 ? 2 : 3
        for _ in 1 : abs(n)
            m = marbles[m[j]]
        end
        m
    end
    
    curmarble = marbles[1]
    curelf = 1
    
    elfscores = zeros(Int, amtelves)
    
    for i in 1 : lastmarble
        if i % 23 != 0
            curmarble = offsetmarble(curmarble, 1)
            insertmarble(curmarble, i)
            curmarble = offsetmarble(curmarble, 1)
        else
            curmarble = offsetmarble(curmarble, -7)
            
            elfscores[curelf] += i + curmarble[1]
            
            deletemarble(curmarble)
            curmarble = offsetmarble(curmarble, 1)
        end
        
        curelf += 1
        if curelf > amtelves
            curelf = 1
        end
    end
    
    maximum(identity, elfscores)
end
