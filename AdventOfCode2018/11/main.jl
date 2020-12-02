

function powerof(x, y, serial)
    id = x + 10
    (id * y + serial) * id ÷ 100 % 10 - 5
end


function part1()
    serial = 8979
    
    ms = 0
    mx = 0
    my = 0
    
    for x in 1 : 298, y in 1 : 298
        s = 0
        for i in 0 : 2, j in 0 : 2
            s += powerof(x + i, y + j, serial)
        end
        
        if s > ms
            ms = s
            mx = x
            my = y
        end
    end
    
    mx, my
end


function part2()
    serial = 8979
    
    allsums = zeros(Int, 300, 300, 300)
    
    for x in 1 : 300, y in 1 : 300
        allsums[x, y, 1] = powerof(x, y, serial)
    end
    
    mcoord = (0, 0, 0)
    ms = 0
    
    for z in 2 : 300
        for x in 1 : 300 - z + 1, y in 1 : 300 - z + 1
            s = allsums[x, y, z - 1]
            for i in 0 : z - 2
                s += allsums[x + i, y + z - 1, 1]
                s += allsums[x + z - 1, y + i, 1]
            end
            s += allsums[x + z - 1, y + z - 1, 1]
            
            allsums[x, y, z] = s
            
            if s > ms
                ms = s
                mcoord = (x, y, z)
            end
        end
    end
    
    mcoord
end
