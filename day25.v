module main

fn d25_loop_size(subj u64, value u64) u64 {
	mut loop_value := u64(1)
	mut i := u64(0)
	for loop_value != value {
		i++
		loop_value *= subj
		loop_value = loop_value % 20201227
	}
	return i
}

fn d25_transform(value u64, range u64) u64 {
	mut result := u64(1)
	for _ in 0 .. range {
		result *= value
		result = result % 20201227
	}
	return result
}

fn day25a() u64 {
	mut lines := read_day('day25.txt').map(it.u64())
	mut r1 := d25_loop_size(7, lines[0])
	return d25_transform(lines[1], r1)
}

fn day25b() u64 {
	return 0
}
