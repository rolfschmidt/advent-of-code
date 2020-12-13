module main

// 410
fn day13a() int {
	mut lines := read_day('day13.txt')
	starttime := lines[0].int()
	mut time := starttime
	mut busses := lines[1].split(',').map(it.int())
	busses.sort()
	daytime: for {
		mut found := 0
		for bus in busses {
			if bus == 0 {
				continue
			}
			if time % bus != 0 {
				continue
			}
			found = bus
			break
		}
		if found == 0 {
			time++
			continue
		}
		return (time - starttime) * found
	}
	return 0
}

fn day13b() u64 {
	mut lines := read_day('day13.txt')
	mut time := u64(0)
	mut busses := lines[1].split(',').map(it.u64())
	mut jmp := u64(1)
	daytime: for {
		mut found := true
		mut found_busses := []u64{}
		for index, bus in busses {
			if bus == 0 {
				continue
			}
			if (time + u64(index)) % bus == 0 {
				found_busses << bus
				continue
			}
			found = false
		}
		if found_busses.len > 1 {
			jmp = au64_product(found_busses)
		}
		if !found {
			time += jmp
			continue
		}
		return time
	}
	return 0
}
