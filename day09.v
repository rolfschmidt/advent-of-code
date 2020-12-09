module main

fn d9_run(lines []u64, base int) u64 {
	LINES:
	for i := 0; i < lines.len; i++ {
		mut pre := lines.slice(i, i + base)
		for x := 0; x < pre.len; x++ {
			for y := 0; y < pre.len; y++ {
				if pre[x] != pre[y] && pre[x] + pre[y] == lines[i + base] {
					continue LINES
				}
			}
		}
		return lines[i + base]
	}
	return 0
}

fn d9_set(lines []u64, find u64) u64 {
	for i := 0; i < lines.len; i++ {
		mut values := []u64{}
		for y := i; y < lines.len; y++ {
			values << lines[y]
			if values.len > 1 && u64_sum(values) == find {
				return u64_min(values) + u64_max(values)
			}
		}
	}
	return 0
}

fn day09a() u64 {
	lines := read_day('day09.txt').map(it.u64())
	return d9_run(lines, 25)
}

fn day09b() u64 {
	lines := read_day('day09.txt').map(it.u64())
	return d9_set(lines, day09a())
}
