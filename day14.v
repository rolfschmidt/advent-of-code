module main

fn day14a() u64 {
	mut lines := read_day('day14.txt')
	mut masks := map[string][][]u64{}
	mut line_mask := ''
	for line in lines {
		if line.contains('mask') {
			line_mask = line[7..]
		} else {
			groups := regex_match(line, r'mem\[(\d+)\] = (\d+)')
			masks[line_mask] << [groups[1].u64(), groups[2].u64()]
		}
	}
	mut memory := map[string]u64{}
	for mask in masks.keys() {
		for mask_data in masks[mask] {
			addr := mask_data[0]
			number := mask_data[1]
			mut bin := decbin(number, 35).split('')
			for i, v in mask {
				if v == `X` {
					continue
				}
				bin[i] = v.str()
			}
			memory[addr.str()] = bindec(bin.join(''))
		}
	}
	mut sum := u64(0)
	for key, value in memory {
		sum += value
	}
	return sum
}

fn day14b() u64 {
	mut lines := read_day('day14.txt')
	return 0
}
