

linetolist(l) = [parse.(Int, split(i, ',')) for i in split(l, ';')]


function betterunion!(s1, s2)
    for el in s2
        push!(s1, el)
    end
end


function main()
    open("generations.txt") do io
        Itype = Int16
        s1 = Vector{Set{Itype}}[]
        s2 = Vector{Set{Itype}}[]
        lnum = 0
        target = Set{Itype}()
        elfnum = -1
        for l in eachline(io)
            lnum += 1
            curline = linetolist(l)
            if isempty(s1)
                s1 = [Set{Itype}([i]) for i in 1 : length(curline)]
                s2 = [Set{Itype}() for _ in 1 : length(curline)]
                target = Set{Itype}(2 : 2 : length(curline))
            end
            
            
            
            for i in 1 : length(curline)
                mor, far = curline[i]
                betterunion!(s2[mor + 1], s1[i])
                betterunion!(s2[far + 1], s1[i])
            end
            
            for i in 1 : length(curline)
                if target ⊆ s2[i]
                    elfnum = i - 1
                    break
                end
            end
            
            if elfnum >= 0
                break
            end
            
            temp = s1
            s1 = s2
            s2 = temp
            
            empty!.(s2)
        end
        lnum, elfnum
    end
end


function main2()
    len = 23738
    
    open("generations.txt") do io
        s1 = zeros(Bool, len, len)
        s2 = zeros(Bool, len, len)
    
        function orinto(a, b)
            for i in 1 : len
                s1[a, i] |= s2[b, i]
            end
        end
        
        target = zeros(Bool, len)
        
        function checktarget(a)
            for i in 1 : len
                if target[i] && !s2[a, i]
                    return false
                end
            end
            true
        end
        
        for i in 1 : len
            s1[i, i] = true
            target[i] = iseven(i)
        end
        
        lnum = 0
        elfnum = -1
        for l in eachline(io)
            @show lnum
            curline = linetolist(l)
            lnum += 1
            
            for i in 1 : len
                mor, far = (curline[i] .+ 1)
                orinto(mor, i)
                orinto(far, i)
            end
            
            for i in 1 : len
                if checktarget(i)
                    elfnum = i - 1
                    break
                end
            end
            
            if elfnum >= 0
                break
            end
            
            temp = s1
            s1 = s2
            s2 = temp
            
            s2 .= false
        end
        lnum, elfnum
    end
end
