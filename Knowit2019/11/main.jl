
function main()
    terreng = open(Vector{Char} ∘ read, "terreng.txt")
    
    vel = 10703437
    pos = 0
    
    mountain = false
    amtice = 0
    
    effects = Dict([
        'G' => () -> vel -= 27,
        'I' => () -> (amtice += 1; vel += amtice * 12),
        'A' => () -> vel -= 59,
        'S' => () -> vel -= 212,
        'F' => () -> (mountain = !mountain; vel += mountain ? -70 : 35)
    ])
    
    while vel > 0
        pos += 1
        
        if terreng[pos] != 'I'
            amtice = 0
        end
        
        effects[terreng[pos]]()
    end
    
    pos
end
