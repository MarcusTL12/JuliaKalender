

function part1()
    img = open(Vector{Char} ∘ String ∘ read, "input.txt", "r")
    l = 25 * 6
    
    layers = length(img) ÷ l
    img = reshape(img, l, layers)
    
    rec = l
    recpos = -1
    
    for i in 1 : layers
        c = count(i->(i == '0'), img[:, i])
        if c < rec
            rec = c
            recpos = i
        end
    end
    
    count(i->i=='1', img[:, recpos]) * count(i->i=='2', img[:, recpos])
end


function part2()
    img = open(Vector{Char} ∘ String ∘ read, "input.txt", "r")
    l = 25 * 6
    
    layers = length(img) ÷ l
    img = reshape(img, l, layers)
    
    finalimg = ['2' for _ in 1 : l]
    
    for i in 1 : l
        j = 1
        while j <= layers && img[i, j] == '2'
            j += 1
        end
        
        if j <= layers
            finalimg[i] = img[i, j]
        end
    end
    
    img = reshape(finalimg, 25, 6)
    
    println.(replace(i, '0' => ' ') for i in (String(img[:, i]) for i in 1 : 6))
    nothing
end
