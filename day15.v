module main

[inline]
fn d15_run(lines string, find int) int {
	mut spoken_before := map[string]int{}
	mut spoken := map[string]int{}
	mut numbers := lines.split(',')
	for i, number in numbers {
		spoken[number.str()] = i
	}
	mut last_number := numbers.last()
	mut last_index := 0
	mut last_index2 := 0
	mut number_str := ''
	for i := numbers.len - 1; i < find - 1; i++ {
		number_str = last_number
		if !spoken.exists(number_str) {
			last_number = '0'
			spoken[number_str] = i
		} else {
			spoken_before[number_str] = spoken[number_str]
			spoken[number_str] = i
			last_index = spoken[number_str]
			last_index2 = 0
			if spoken_before.exists(number_str) {
				last_index2 = spoken_before[number_str]
			}
			if last_index == i && last_index2 == i - 1 {
				last_number = '1'
			} else {
				last_number = ((last_index + 1) - (last_index2 + 1)).str()
			}
		}
	}
	return last_number.int()
}

fn day15a() int {
	mut lines := read_day_string('day15.txt')
	return d15_run(lines, 2020)
}

fn day15b() int {
	mut lines := read_day_string('day15.txt')
	return d15_run(lines, 30000000)
}
