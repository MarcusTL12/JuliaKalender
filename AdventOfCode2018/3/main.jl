

function part1()
    claims = Dict{Tuple{Int, Int}, Int}()
    
    function inc_claim(k)
        if !haskey(claims, k)
            claims[k] = 0
        end
        claims[k] += 1
    end
    
    r = r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)"
    
    open("input.txt") do io
        for l in eachline(io)
            _, x, y, w, h = parse.(Int, match(r, l).captures)
            inc_claim.((i, j) for i in x + 1 : x + w, j in y + 1 : y + h)
        end
    end
    
    count(x->x>1, values(claims))
end


function part2()
    tiles = Dict{Tuple{Int, Int}, Set{Int}}()   # position => claimers
    claims = Dict{Int, Set{Tuple{Int, Int}}}()  # claimer => positions
    
    function add_tile_claim(id, k)
        if !haskey(tiles, k)
            tiles[k] = Set([id])
        else
            push!(tiles[k], id)
        end
    end
    
    function add_claim(id, ks)
        claims[id] = Set(ks)
        add_tile_claim.(id, ks)
    end
    
    r = r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)"
    
    open("input.txt") do io
        for l in eachline(io)
            id, x, y, w, h = parse.(Int, match(r, l).captures)
            add_claim(id, (i, j) for i in x + 1 : x + w, j in y + 1 : y + h)
        end
    end
    
    for (id, claim) in claims
        the_one = true
        for tile in claim
            if length(tiles[tile]) > 1
                the_one = false
            end
        end
        if the_one
            return id
        end
    end
end
