

function loadfile(filename)
    open(filename) do io
        hcat([
            parse.(
                Int, match(r"<x=(-?\d+), y=(-?\d+), z=(-?\d+)>", l).captures
            )
            for l in eachline(io)
        ]...)
    end
end


function part1()
    pos = loadfile("example1.txt")
    vel = zeros(Int, size(pos))
    
    dim, moons = size(pos)
    
    function applygravity()
        for i in 1 : moons - 1
            for j in i + 1 : moons
                Δ = sign.(pos[:, j] - pos[:, i])
                vel[:, i] .+= Δ
                vel[:, j] .-= Δ
            end
        end
    end
    
    function move()
        for i in 1 : moons
            pos[:, i] += vel[:, i]
        end
    end
    
    function totenergy(i)
        sum(abs.(pos[:, i])) * sum(abs.(vel[:, i]))
    end
    
    for _ in 1 : 1386
        applygravity()
        move()
    end
    
    # sum(totenergy.(1 : moons))
    
    pos
end


function part2(filename)
    pos = loadfile(filename)
    vel = zeros(Int, size(pos))
    
    startpos = copy(pos)
    startvel = copy(vel)
    
    dim, moons = size(pos)
    
    function applygravity()
        for i in 1 : moons - 1
            for j in i + 1 : moons
                Δ = sign.(pos[:, j] - pos[:, i])
                vel[:, i] .+= Δ
                vel[:, j] .-= Δ
            end
        end
    end
    
    function move()
        for i in 1 : moons
            pos[:, i] += vel[:, i]
        end
    end
    
    applygravity()
    move()
    
    i = 1
    t = time()
    
    while pos != startpos || vel != startvel
        applygravity()
        move()
        i += 1
        
        if (tn = time()) - t > 1
            t = tn
            println(round(i / 4686774924 * 100; digits=2))
        end
    end
    
    i
end


function part2()
    pos = loadfile("input.txt")
    vel = zeros(Int, size(pos))
    
    startpos = copy(pos)
    startvel = copy(vel)
    
    dim, moons = size(pos)
    
    function applygravity()
        for i in 1 : moons - 1
            for j in i + 1 : moons
                Δ = sign.(pos[:, j] - pos[:, i])
                vel[:, i] .+= Δ
                vel[:, j] .-= Δ
            end
        end
    end
    
    function move()
        for i in 1 : moons
            pos[:, i] += vel[:, i]
        end
    end
    
    t = 0
    
    periods = zeros(Int, dim)
    
    while mapfoldl(x->x==0, (a,b)->a||b, periods)
        applygravity()
        move()
        t += 1
        
        for i in 1 : dim
            if periods[i] == 0
                if pos[i, :] == startpos[i, :] && vel[i, :] == startvel[i, :]
                    periods[i] = t
                end
            end
        end
    end
    
    lcm(periods...)
end
