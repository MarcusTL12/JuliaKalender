
function scramble(ønske)
    ønske = Vector{Char}(ønske)
    l = length(ønske)
    ønske[1 : l ÷ 2], ønske[l ÷ 2 + 1 : end] =
    ønske[l ÷ 2 + 1 : end], ønske[1 : l ÷ 2]
    
    for i in 1 : 2 : l
        ønske[i : i + 1] = ønske[i + 1 : - 1 : i]
    end
    
    for i in 1 : 3 : l ÷ 2
        ønske[i : i + 2], ønske[l - i - 1 : l - i + 1] =
        ønske[l - i - 1 : l - i + 1], ønske[i : i + 2]
    end
    
    String(ønske)
end


function unscramble(ønske)
    ønske = Vector{Char}(ønske)
    l = length(ønske)
    
    for i in 1 : 3 : l ÷ 2
        ønske[i : i + 2], ønske[l - i - 1 : l - i + 1] =
        ønske[l - i - 1 : l - i + 1], ønske[i : i + 2]
    end
    
    for i in 1 : 2 : l
        ønske[i : i + 1] = ønske[i + 1 : - 1 : i]
    end
    
    ønske[1 : l ÷ 2], ønske[l ÷ 2 + 1 : end] =
    ønske[l ÷ 2 + 1 : end], ønske[1 : l ÷ 2]
    
    String(ønske)
end


function quickunscramble(ønske)
    l = length(ønske)
    l2 = l ÷ 2
    
    for i in 1 : 3 : l2
        for j in 0 : 2
            p1 = i + j
            p2 = l - i - 1 + j
            t = ønske[p1]
            ønske[p1] = ønske[p2]
            ønske[p2] = t
        end
    end
    
    for i in 1 : 2 : l
        t = ønske[i]
        ønske[i] = ønske[i + 1]
        ønske[i + 1] = t
    end
    
    for i in 1 : l2
        t = ønske[i]
        ønske[i] = ønske[l2 + i]
        ønske[l2 + i] = t
    end
end

function quickunscramble2(ønske)
    l = length(ønske)
    l2 = l ÷ 2
    
    i = 1
    while i <= l2
        j = 0
        while j <= 2
            p1 = i + j
            p2 = l - i - 1 + j
            t = ønske[p1]
            ønske[p1] = ønske[p2]
            ønske[p2] = t
            j += 1
        end
        i += 3
    end
    
    i = 1
    while i <= l
        t = ønske[i]
        ønske[i] = ønske[i + 1]
        ønske[i + 1] = t
        i += 2
    end
    
    i = 1
    while i <= l2
        t = ønske[i]
        ønske[i] = ønske[l2 + i]
        ønske[l2 + i] = t
        i += 1
    end
end


function main()
    # input = "oepHlpslainttnotePmseormoTtlst"
    input = "tMlsioaplnKlflgiruKanliaebeLlkslikkpnerikTasatamkDpsdakeraBeIdaegptnuaKtmteorpuTaTtbtsesOHXxonibmksekaaoaKtrssegnveinRedlkkkroeekVtkekymmlooLnanoKtlstoepHrpeutdynfSneloietbol"
    # inp1 = copy(Vector{UInt8}(input))
    inp2 = Vector{Char}(input)
    @time for i in 1 : 10000000
        quickunscramble2(inp2)
        # if inp2 == inp1
        #     println(i)
        #     break
        # end
    end
    # String(input)
end
