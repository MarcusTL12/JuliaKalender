using Images

function main()
    img = load("mush.png") |> transpose
    v = reshape(img |> channelview |> rawview, (3, 183 * 275))
    for i in 183 * 275 : -1 : 2
        v[:, i] .⊻= v[:, i - 1]
    end
    save("unmush.png", img |> transpose)
end
