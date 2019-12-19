
palindrome(n) = (s = string(n)) == reverse(s)


function hiddenpalindrome(n)
    palindrome(n + parse(Int, reverse(string(n)))) && !palindrome(n)
end


function main()
    sum(filter(hiddenpalindrome, 1 : 123454321))
end
