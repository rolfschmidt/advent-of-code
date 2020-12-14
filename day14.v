module main

fn bit_combos(arr []int, pos int) [][]int {
	mut result := [][]int{}
	if pos > arr.len - 1 {
		return result
	}
	mut arr_pos := []int{}
	mut arr_neg := []int{}
	for index, value in arr {
		if index == pos {
			arr_pos << 1
			arr_neg << 0
			continue
		}
		arr_pos << value
		arr_neg << value
	}
	result << arr_pos
	result << arr_neg
	for sub in bit_combos(arr_pos, pos + 1) {
		result << sub
	}
	for sub in bit_combos(arr_neg, pos + 1) {
		result << sub
	}
	return result
}

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
	for _, value in memory {
		sum += value
	}
	return sum
}

fn day14b() u64 {
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
			mut bin := decbin(addr, 35).split('')
			mut xarr := []int{}
			for i, v in mask {
				if v == `0` {
					continue
				}
				if v == `X` {
					xarr << i
					bin[i] = '0'
					continue
				}
				bin[i] = v.str()
			}
			mut addrs := map[string]bool{}
			mut combos := bit_combos(xarr.map(int(0)), 0)
			for combo in combos {
				for xi, xv in xarr {
					bin[xv] = combo[xi].str()
				}
				addrs[bin.join('')] = true
			}
			for key in addrs.keys() {
				memory[bindec(key).str()] = number
			}
		}
	}
	mut sum := u64(0)
	for _, value in memory {
		sum += value
	}
	return sum
}
