package palette_gen


import "core:hash"

import "vendor:stb/image"


main :: proc() {
	img := create_unique_pallet()
	image.write_png("pallete.png", 256, 1, 3, &img, 4)
}

create_unique_pallet :: proc(seed: u32 = 0) -> [256 * 4]byte {
	buf: [256 * 4]byte
	for i in 0 ..= 255 {
		h := hash.crc32({cast(u8)i}, seed)
		buf[i] = u8(h & 0xFF0000 >> 16)
		buf[i + 1] = u8(h & 0x00FF00 >> 8)
		buf[i + 2] = u8(h & 0x0000FF)
		buf[i + 3] = 255
	}

	return buf
}
