using Plots


function main()
    data = open("turer.txt") do io
        s = split.(split(String(read(io)), "\n---\n"), '\n')
        
        [hcat([parse.(Int, split(i, ',')) for i in t]...) for t in s]
    end
    
    for i in 1 : length(data)
        tur = data[i]
        scatter(tur[1, :], tur[2, :])
        savefig("$i.png")
    end
end
