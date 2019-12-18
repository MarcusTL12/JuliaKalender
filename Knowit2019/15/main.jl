using LinearAlgebra


function main()
    model = open("model.csv") do io
        hcat(
            (
                parse.(Float64, split(l, ','))
                for l in eachline(io)
            )...
        )
    end
    
    _, amt_triangles = size(model)
    
    acc = 0
    
    for i in 1 : amt_triangles
        acc += det(reshape(model[:, i], 3, 3)) / 6
    end
    
    round(acc) / 1000
end
