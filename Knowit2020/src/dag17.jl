

function load_map(filename)
    open(filename) do io
        w = 0
        h = 0
        kart = falses(0)
        for l in eachline(io)
            w = length(l)
            h += 1
            for c in l
                push!(kart, c != ' ')
            end
        end
        reshape(kart, (w, h))
    end
end


function pad_kart(kart)
    h, w = size(kart)
    pad_kart = trues(h + 2, w + 2)
    pad_kart[2:end-1, 2:end-1] .= kart
    pad_kart
end


function main()
    kart = pad_kart(load_map("inputfiles/dag17/kart.txt"))
    støvsuger = load_map("inputfiles/dag17/støvsuger.txt")
    koster = load_map("inputfiles/dag17/koster.txt")
    
    skittent = [!x for x in kart]
    
    h, w = size(kart)
    sh, sw = size(støvsuger)
    kh, kw = size(koster)
    
    for y in 1:h - sh, x in 1:w - sw
        if !any(kart[y + i, x + j] && støvsuger[i, j]
            for i in 1:sh, j in 1:sw)
            for i in 1:kh, j in 1:kw
                ny = y + i - 1
                nx = x + j - 1
                if 1 <= ny <= h && 1 <= nx <= w && koster[i, j]
                    skittent[ny, nx] = false
                end
            end
        end
    end
    count(skittent)
end
