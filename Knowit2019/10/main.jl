using Dates

function main()
    s = open(String ∘ read, "logg.txt")
    
    months = Dict([monthname(i)[1:3] => i for i in 1 : 12])
    
    tannkrem = 0
    sjampo = 0
    dopapir = 0
    søndagsjampo = 0
    onsdagsdopapir = 0
    
    r = r"""(\w+) (\d+):
        \s*\* (\d+) \w+ (\w+)
        \s*\* (\d+) \w+ (\w+)
        \s*\* (\d+) \w+ (\w+)"""
    for m in eachmatch(r, s)
        d = Date(2018, months[m.captures[1]], parse(Int, m.captures[2]))
        usage = Dict([
            "tannkrem" => 0,
            "sjampo" => 0,
            "toalettpapir" => 0
        ])
        
        usage[m.captures[4]] = parse(Int, m.captures[3])
        usage[m.captures[6]] = parse(Int, m.captures[5])
        usage[m.captures[8]] = parse(Int, m.captures[7])
        
        tannkrem += usage["tannkrem"]
        sjampo += usage["sjampo"]
        dopapir += usage["toalettpapir"]
        
        if dayname(d) == "Sunday"
            søndagsjampo += usage["sjampo"]
        elseif dayname(d) == "Wednesday"
            onsdagsdopapir += usage["toalettpapir"]
        end
    end
    
    prod((
        tannkrem ÷ 125,
        sjampo ÷ 300,
        dopapir ÷ 25,
        søndagsjampo,
        onsdagsdopapir
    ))
end
