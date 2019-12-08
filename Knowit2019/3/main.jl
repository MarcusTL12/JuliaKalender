using Images
transpose(reshape(Gray{Float16}.(i - 0x30 for i in open(read, "img.txt", "r")), 1287, 560))
