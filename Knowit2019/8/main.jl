
const wheels_src = open("wheels.txt", "r") do io
    [
        [match(r"Hjul \d+: (\w+), (\w+), (\w+), (\w+)", l).captures...]
        for l in eachline(io)
    ]
end

function runlotto(score)
    done = false
    
    indices = [1 for _ in wheels_src]
    
    incwheel(i) = (
        a = indices[i]; ((indices[i] += 1) > 4) && (indices[i] = 1); a
    )
    
    ops = Dict([
        "PLUSS4"         => () -> score += 4,
        "PLUSS101"       => () -> score += 101,
        "MINUS9"         => () -> score -= 9,
        "MINUS1"         => () -> score -= 1,
        "REVERSERSIFFER" => () -> score =
            parse(Int, string(abs(score))[end:-1:1]) * sign(score),
        "OPP7"           => () -> begin
            inc = 7 - score % 10
            (inc < 0) && (inc += 10)
            score += inc
        end,
        "GANGEMSD" => () -> score *= parse(Int, string(abs(score))[1]),
        "DELEMSD"  => () -> score ÷= parse(Int, string(abs(score))[1]),
        "PLUSS1TILPAR" => () -> begin
            s = sign(score)
            digits = parse.(Int, string(abs(score)) |> Vector{Char})
            for i in 1 : length(digits)
                if digits[i] |> iseven
                    digits[i] += 1
                end
            end
            score = s * parse(Int, String([i[1] for i in string.(digits)]))
        end,
        "TREKK1FRAODDE" => () -> begin
            s = sign(score)
            digits = parse.(Int, string(abs(score)) |> Vector{Char})
            for i in 1 : length(digits)
                if digits[i] |> isodd
                    digits[i] -= 1
                end
            end
            score = s * parse(Int, String([i[1] for i in string.(digits)]))
        end,
        "ROTERPAR" => () -> begin
            for i in 1 : 2 : length(indices)
                incwheel(i)
            end
        end,
        "ROTERODDE" => () -> begin
            for i in 2 : 2 : length(indices)
                incwheel(i)
            end
        end,
        "ROTERALLE" => () -> begin
            for i in 1 : length(indices)
                incwheel(i)
            end
        end,
        "STOPP" => () -> done = true
    ])
    
    wheels = [[ops[i] for i in w] for w in wheels_src]
    
    while !done
        i = abs(score) % 10
        wheels[i + 1][incwheel(i + 1)]()
    end
    
    score
end

function main()
    max((runlotto(i) for i in 0 : 10)...)
end
