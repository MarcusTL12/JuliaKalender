
function main()
    open(
        io -> sum(
            length(m.captures[1])
            for m in eachmatch(r"(?<=\#)(\ +)(?=\#)", String(read(io)))
        ),
        "world.txt", "r"
    )
end
