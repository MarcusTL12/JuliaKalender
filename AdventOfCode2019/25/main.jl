include("../intcode.jl")

# Might be useful for other stuff later
function rendermaze(maze, pos)
    minx = minimum(x->x[1], keys(maze))
    miny = minimum(x->x[2], keys(maze))
    maxx = maximum(x->x[1], keys(maze))
    maxy = maximum(x->x[2], keys(maze))
    
    tiles = Dict([
        ( true,  true,  true,  true) => '╬',
        ( true,  true,  true, false) => '╠',
        ( true,  true, false,  true) => '╩',
        ( true,  true, false, false) => '╚',
        ( true, false,  true,  true) => '╣',
        ( true, false,  true, false) => '║',
        ( true, false, false,  true) => '╝',
        ( true, false, false, false) => '║',
        (false,  true,  true,  true) => '╦',
        (false,  true,  true, false) => '╔',
        (false,  true, false,  true) => '═',
        (false,  true, false, false) => '═',
        (false, false,  true,  true) => '╗',
        (false, false,  true, false) => '║',
        (false, false, false,  true) => '═',
        (false, false, false, false) => '█'
    ])
    
    for i in miny : maxy
        for j in minx : maxx
            if (j, i) == pos
                '#'
            elseif haskey(maze, (j, i))
                tiles[maze[(j, i)][2]]
            else
                ' '
            end |> print
        end
        println()
    end
end


function playgame()
    program = loadprogram("input.txt")
    
    out, done, state = runintcode!(program)
    
    while !done
        println(String(Char.(out)))
        
        com = readline()
        
        out, done, state = runintcode!(
            program,
            Int.(Vector{Char}(com * '\n')),
            state
        )
    end
    
    println(String(Char.(out)))
end


function autoplay()
    program = loadprogram("input.txt")
    
    reg1 = r"== (.+) =="
    reg2 = r"Doors here lead:\n((?:- .+\n)+)"
    reg3 = r"Items here:\n((?:- .+\n)+)"
    
    out, done, state = runintcode!(program)
    
    curroom = ""
    cdir = ""
    
    maze = Dict{String, Dict{String, String}}()
    
    doors = String[]
    items = String[]
    
    allitems = Set{String}()
    inventory = Set{String}()
    
    itemblacklist = Set([
        "photons",
        "infinite loop",
        "escape pod",
        "giant electromagnet",
        "molten lava"
    ])
    
    directions = [
        "north",
        "east",
        "south",
        "west"
    ]
    
    invdir = Dict([
        "north" => "south",
        "east"  => "west",
        "south" => "north",
        "west"  => "east"
    ])
    
    path = String[]
    pathtosecroom = String[]
    
    donemapping = false
    insecroom = false
    
    itemsbools = falses(0)
    pickupqueue = String[]
    inventoryorder = String[]
    
    while !done
        outs = String(Char.(out))
        
        nroom = ""
        
        for m in eachmatch(reg1, outs)
            nroom = m.captures[]
        end
        
        if (m = match(reg2, outs)) !== nothing
            doors = [l[3:end] for l in split(m.captures[], '\n')[1:end - 1]]
        end
        
        if (m = match(reg3, outs)) !== nothing
            items = [l[3:end] for l in split(m.captures[], '\n')[1:end - 1]]
        end
        
        
        if nroom != "" && nroom != curroom
            if !haskey(maze, nroom)
                maze[nroom] = Dict(doors .=> "")
                
                if cdir != ""
                    maze[nroom][invdir[cdir]] = curroom
                end
                
                if curroom != ""
                    maze[curroom][cdir] = nroom
                end
            end
            
            curroom = nroom
        end
        
        if curroom == "Security Checkpoint"
            pathtosecroom = copy(path)
            maze[curroom]["east"] = "Pressure-Sensitive Floor"
        end
        
        union!(allitems, items)
        
        # display(maze)
        # println(outs)
        
        
        # if insecroom
        #     readline()
        # end
        com = ""
        
        if !donemapping
            while !isempty(items) && com == ""
                item = pop!(items)
                if item ∉ itemblacklist
                    com = "take $item"
                    push!(inventory, item)
                end
            end
            
            if com == ""
                for d in directions
                    if haskey(maze[curroom], d) && maze[curroom][d] == ""
                        com = d
                        push!(path, d)
                        break
                    end
                end
            end
            
            if com == ""
                if !isempty(path)
                    com = invdir[pop!(path)]
                end
            end
            
            (donemapping = com == "") && continue
            
            if com in directions
                cdir = com
            end
        elseif !insecroom
            if !isempty(pathtosecroom)
                com = popfirst!(pathtosecroom)
            else
                insecroom = true
                itemsbools = falses(length(inventory))
                for i in inventory
                    push!(pickupqueue, "drop $i")
                    push!(inventoryorder, i)
                end
                continue
            end
        else
            if !isempty(pickupqueue)
                com = popfirst!(pickupqueue)
            else
                i = 1
                while i <= length(inventoryorder)
                    itemsbools[i] = !itemsbools[i]
                    if !itemsbools[i]
                        push!(pickupqueue, "drop $(inventoryorder[i])")
                    else
                        push!(pickupqueue, "take $(inventoryorder[i])")
                        break
                    end
                    i += 1
                end
                push!(pickupqueue, "east")
                # println(itemsbools)
                com = popfirst!(pickupqueue)
            end
        end
        
        # printstyled(com, '\n'; color=:red)
        
        out, done, state = runintcode!(
            program,
            Int.(Vector{Char}(com * '\n')),
            state
        )
    end
    
    println(String(Char.(out)))
    
    [inventoryorder[i] for i in 1 : length(inventoryorder) if itemsbools[i]]
end
