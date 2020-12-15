module main

[inline]
fn d15_run(lines string, find int) int {
	mut spoken_before := map[string]int{}
	mut spoken := map[string]int{}
	mut numbers := lines.split(',')

	for i := 0; i < numbers.len; i++ {
		number_str := numbers[i]

		if i == numbers.len - 1 {
			if !spoken.exists(number_str) {
				numbers << '0'
				spoken[number_str] = i
			}
			else {
				spoken_before[number_str] = spoken[number_str]
				spoken[number_str] = i

				last_index := spoken[number_str]
				mut last_index2 := 0
				if spoken_before.exists(number_str) {
					last_index2 = spoken_before[number_str]
				}

				if last_index == i && last_index2 == i - 1 {
					numbers << '1'
				}
				else {
					numbers << ((last_index + 1) - (last_index2 + 1)).str()
				}
			}
		}
		else {
			spoken[number_str] = i
		}
		if i == find - 2 {
			return numbers.last().int()
		}
	}

	return 0
}

fn day15a() int {
	mut lines := read_day_string('day15.txt')
	return d15_run(lines, 2020)
}

fn day15b() int {
	mut lines := read_day_string('day15.txt')
	return d15_run(lines, 30000000)
}
