
function part1()
    orbits = open(
        io -> Dict{String, String}(
            (s = split(l, ')'); s[2] => s[1]) for l in eachline(io)
        ),
        "example.txt", "r"
    )
    
    paths = Dict(keys(orbits) .=> 0)
    
    function traversefrom(k)
        k == "COM" && return 0
        
        if paths[k] != 0
            paths[k]
        else
            paths[k] = traversefrom(orbits[k]) + 1
        end
    end
    
    traversefrom.(keys(orbits))
    
    # paths |> values |> sum
    paths
end


function part2()
    orbits = open(
        io -> Dict{String, String}(
            (s = split(l, ')'); s[2] => s[1]) for l in eachline(io)
        ),
        "input.txt", "r"
    )
    
    paths = Dict(keys(orbits) .=> 0)
    
    function traversefrom(k)
        k == "COM" && return 0
        
        if paths[k] != 0
            paths[k]
        else
            paths[k] = traversefrom(orbits[k]) + 1
        end
    end
    
    function path(k)
        k == "COM" && return ["COM"]
        
        push!(path(orbits[k]), k)
    end
    
    yp = path("YOU")
    sp = path("SAN")
    
    common = let i = 1
        while yp[i] == sp[i]
            i += 1
        end
        yp[i - 1]
    end
    
    traversefrom("YOU") + traversefrom("SAN") - traversefrom(common) * 2 - 2
end
