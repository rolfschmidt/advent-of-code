module main

fn d23_run(part2 bool) string {
	mut input := read_day_string('day23.txt').split('')
	mut ring := map[string]string{}
	mut curr := ''
	mut prev := ''
	mut input_min := 999
	mut input_max := 0
	mut rounds := 100
	for v in input {
		if curr.len < 1 {
			curr = v
		}
		if prev.len > 0 {
			ring[prev] = v
		}
		prev = v
		input_min = int_min(input_min, v.int())
		input_max = int_max(input_max, v.int())
	}
	if part2 {
		rounds = 10000000
		input_max = 1000000
		for v in 10 .. 1000001 {
			ring[prev] = v.str()
			prev = v.str()
		}
		ring['1000000'] = curr
	} else {
		ring[input.last()] = curr
	}
	for r := 0; r < rounds; r++ {
		p1 := ring[curr]
		p2 := ring[p1]
		p3 := ring[p2]
		mut d := curr.int()
		for d == curr.int() || d == p1.int() || d == p2.int() || d == p3.int() {
			d--
			if d < input_min {
				d = input_max
			}
		}
		ring[curr] = ring[p3]
		dt := ring[d.str()]
		ring[d.str()] = p1
		ring[p3] = dt
		curr = ring[curr]
	}
	if !part2 {
		mut result := ''
		mut si := '1'
		for {
			val := ring[si]
			if val == '1' {
				break
			}
			result += val
			si = val
		}
		return result
	} else {
		return (ring['1'].u64() * ring[ring['1']].u64()).str()
	}
	return '-1'
}

fn day23a() string {
	return d23_run(false)
}

fn day23b() string {
	return d23_run(true)
}
