
const program = parse.(Int, split(open(String ∘ read, "input.txt", "r"), ","))

function run((a, b))
    p = copy(program)
    p[2] = a
    p[3] = b
    # program = [1,9,10,3,2,3,11,0,99,30,40,50]
    
    pc = 1
    
    while true
        if p[pc] == 99
            break
        end
        f = (p[pc] == 1) ? (+) : (*)
        p[p[pc + 3] + 1] = f(
            p[p[pc + 1] + 1], p[p[pc + 2] + 1]
        )
        pc += 4
    end
    p[1]
end
