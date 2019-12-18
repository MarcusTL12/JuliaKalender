
include("../intcode.jl")

function part1()
    program = loadprogram("input.txt")
    
    hull = Dict{Complex{Int}, Int}()
    
    getpaint(pos) = haskey(hull, pos) ? hull[pos] : 0
    
    curpos = 0 + 0im
    dir = 1im
    
    i = 0
    
    (col, dir_change), done, pc = runintcode!(program, [0])
    
    while !done
        hull[curpos] = col
        dir *= ((dir_change * (-2) + 1) * 1im)
        curpos += dir
        
        p = getpaint(curpos)
        
        i < 20 && (@show (pc[1]))
        
        (col, dir_change), done, pc =
        runintcode!(program, [p], pc)
        i += 1
    end
    
    length(keys(hull))
end


function part2()
    program = loadprogram("input.txt")
    
    hull = Dict{Complex{Int}, Int}()
    
    getpaint(pos) = haskey(hull, pos) ? hull[pos] : 0
    
    curpos = 0 + 0im
    dir = 1im
    
    
    (col, dir_change), done, pc = runintcode!(program, [1])
    
    while !done
        hull[curpos] = col
        dir *= ((dir_change * (-2) + 1) * 1im)
        curpos += dir
        
        p = getpaint(curpos)
        
        (col, dir_change), done, pc =
        runintcode!(program, [p], pc)
    end
    
    upperleft = [0, 0]
    lowerright = [0, 0]
    
    for k in keys(hull)
        if real(k) < upperleft[1]
            upperleft[1] = real(k)
        end
        if -imag(k) < upperleft[2]
            upperleft[2] = -imag(k)
        end
        if real(k) > lowerright[1]
            lowerright[1] = real(k)
        end
        if -imag(k) > lowerright[2]
            lowerright[2] = -imag(k)
        end
    end
    
    out = zeros(Int,
        lowerright[2] - upperleft[2] + 1, lowerright[1] - upperleft[1] + 1
    )
    
    for k in keys(hull)
        out[-imag(k) + 1, real(k) + 1] = hull[k]
    end
    
    out = [i == 0 ? ' ' : '█' for i in out]
    
    println.(String(out[i, :]) for i in 1 : size(out)[1])
    nothing
end
