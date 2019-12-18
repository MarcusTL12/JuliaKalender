

function main()
    alphabet = [2, 3, 5, 7, 11]
    
    seq = [alphabet[1] for _ in 1 : alphabet[1]]
    
    target = 217532235
    
    sizehint!(seq, target)
    
    alph_index = 2
    seq_index = 2
    
    while length(seq) < target
        for _ in 1 : seq[seq_index]
            push!(seq, alphabet[alph_index])
        end
        
        seq_index += 1
        alph_index += 1
        
        if alph_index > length(alphabet)
            alph_index = 1
        end
    end
    
    count(x->x==7, seq) * 7
end

function main2()
    alphabet = [2, 3, 5, 7, 11]
    
    target = 217532235
    seq = zeros(Int, target)
    
    top = 0
    
    for _ in 1 : alphabet[1]
        seq[top += 1] = alphabet[1]
    end
    
    alph_index = 2
    seq_index = 2
    
    while top < target
        for _ in 1 : seq[seq_index]
            seq[top += 1] = alphabet[alph_index]
        end
        
        seq_index += 1
        alph_index += 1
        
        if alph_index > length(alphabet)
            alph_index = 1
        end
    end
    
    count(x->x==7, seq) * 7
end
