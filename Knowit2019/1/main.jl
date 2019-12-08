
function main()
    sheep = parse.(
        Int, split(open(String ∘ read, "sau.txt", "r"), ", ")
    )
    
    days_without_food = 0
    leftover_sheep = 0
    dragon_size = 50
    days_survived = 1
    
    while days_without_food < 5 && days_survived <= length(sheep)
        sheep_today = sheep[days_survived] + leftover_sheep
        if sheep_today >= dragon_size
            leftover_sheep = sheep_today - dragon_size
            dragon_size += 1
            days_without_food = 0
        else
            days_without_food += 1
            dragon_size -= 1
            leftover_sheep = 0
        end
        days_survived += 1
    end
    
    days_survived - 2
end
