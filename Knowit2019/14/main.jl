

function main()
    alphabet = [2, 3, 5, 7, 11]
    
    target = 217532235
    seq = zeros(Int, target)
    top = 1
    
    function fillseq(v, n)
        while n > 0
            seq[top] = v
            top += 1
            n -= 1
        end
    end
    
    fillseq(alphabet[1], alphabet[1])
    
    alph_index = 2
    seq_index = 2
    
    while top < target
        fillseq(alphabet[alph_index], seq[seq_index])
        seq_index += 1
        alph_index += 1
        
        if alph_index > length(alphabet)
            alph_index = 1
        end
    end
    
    count(x->x==7, seq) * 7
end
