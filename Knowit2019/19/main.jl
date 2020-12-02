

amtdigits(n) = floor(Int, log10(n) + 1)


function reversenum(n)
    d = amtdigits(n)
    
    nnum = 0
    
    for i in 1 : d
        nnum *= 10
        nnum += n % 10
        n ÷= 10
    end
    
    nnum
end


palindrome(n) = n == reversenum(n)


function hiddenpalindrome(n)
    palindrome(n + reversenum(n)) && !palindrome(n)
end


function main()
    sum(filter(hiddenpalindrome, 1 : 123454321))
end


function main2()
    acc = 0
    for i in 1 : 123454321
        if hiddenpalindrome(i)
            acc += i
        end
    end
    acc
end
