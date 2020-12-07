

amt_alv = 127

function main()
    godteri = open("inputfiles/dag6/godteri.txt") do io
        sort!(parse.(Int, split(String(read(io)), ',')); rev=true)
    end
    
    godteri_per = 0
    pakker = 0
    
    amt_pakker_in_pool = 0
    cur_godteri = 0
    
    for pakke in godteri
        amt_pakker_in_pool += 1
        cur_godteri += pakke
        if cur_godteri % amt_alv == 0
            godteri_per += cur_godteri ÷ amt_alv
            pakker += amt_pakker_in_pool
            cur_godteri = 0
            amt_pakker_in_pool = 0
        end
    end
    
    "$godteri_per,$pakker"
end
