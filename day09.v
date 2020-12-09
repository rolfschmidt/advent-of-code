module main

fn d9_run(lines []string, base int) u64 {
	for i := 0; i < lines.len; i++ {
		if lines.len < i + base * 2 {
			break
		}
		mut pre := []u64{}
		for j := i; j < i + base; j++ {
			pre << lines[j].u64()
		}
		mut found := false
		for x := 0; x < pre.len; x++ {
			for y := 0; y < pre.len; y++ {
				if pre[x] == pre[y] {
					continue
				}
				val := pre[x] + pre[y]
				if val == lines[i + base].u64() {
					found = true
					break
				}
			}
			if found {
				break
			}
		}
		if !found {
			return lines[i + base].u64()
		}
	}
	return 0
}

fn (arr []u64) min() u64 {
	mut low := u64(0)
	mut found := false
	for value in arr {
		if value < low || !found {
			low = value
			found = true
		}
	}
	return low
}

fn (arr []u64) max() u64 {
	mut high := u64(0)
	mut found := false
	for value in arr {
		if value > high {
			high = value
			found = true
		}
	}
	return high
}

fn (arr []u64) sum() u64 {
	mut result := u64(0)
	for value in arr {
		result += value
	}
	return result
}

fn d9_set(lines []string, find u64) u64 {
	for i := 0; i < lines.len; i++ {
		if lines.len < i + 4 {
			break
		}
		mut values := []u64{}
		for y := i; y < lines.len; y++ {
			values << lines[y].u64()
			if values.len < 2 {
				continue
			}
			if values.sum() == find {
				return values.min() + values.max()
			}
		}
	}
	return 0
}

fn day09a() u64 {
	lines := read_day('day09.txt')
	return d9_run(lines, 25)
}

fn day09b() u64 {
	lines := read_day('day09.txt')
	return d9_set(lines, day09a())
}
