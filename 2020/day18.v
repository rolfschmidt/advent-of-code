module main

fn d18_combine(val string, part2 bool) (bool, string) {
	mut ls := val
	mut changed := false
	mut regex_default := r'(\d+)(\*|\+)(\d+)'
	mut regex_equal := regex_default
	mut regex_add := r'(\d+)(\+)(\d+)'
	mut regex := regex_equal
	if part2 {
		regex_equal = r'(?:^|[*\(\)])(\d+)(\*)(\d+)(?:$|[*\(\)])'
		regex = regex_add
	}
	for {
		mut operation := regex_match(ls, regex)
		if operation.len < 1 {
			if part2 && regex == regex_add {
				regex = regex_equal
				ls = d18_reverse_calculation(ls)
				continue
			}
			break
		}
		if part2 && regex == regex_equal {
			operation = regex_match(operation[0], regex_default)
		}
		if operation[2] == '*' {
			ls = ls.replace_once(operation[0], (operation[1].u64() * operation[3].u64()).str())
			if part2 && regex == regex_equal {
				regex = regex_add
				ls = d18_reverse_calculation(ls)
			}
		} else {
			ls = ls.replace_once(operation[0], (operation[1].u64() + operation[3].u64()).str())
		}
		ls = d18_string_drop_clamps(ls)
		changed = true
	}
	return changed, ls
}

fn d18_string_drop_clamps(val string) string {
	mut ls := val
	for {
		operation := regex_match(ls, r'\((\d+)\)')
		if operation.len < 1 {
			break
		}
		ls = ls.replace(operation[0], operation[1])
	}
	return ls
}

fn d18_reverse_calculation(ls string) string {
	mut ls_split := regex_split(ls, r'(\d+|.)').reverse()
	for i, v in ls_split {
		ls_split[i] = string_flip(v, ')', '(')
	}
	return ls_split.join('')
}

fn d18_string_calculate(val string, part2 bool) u64 {
	mut ls := val.replace(' ', '')
	if part2 {
		ls = d18_reverse_calculation(ls)
	}
	mut changed := false
	for {
		changed, ls = d18_combine(ls, part2)
		if !changed {
			break
		}
	}
	return ls.u64()
}

fn day18a() u64 {
	mut lines := read_day('day18.txt')
	mut result := u64(0)
	for line in lines {
		mut ls := d18_string_calculate(line, false)
		result += ls
	}
	return result
}

fn day18b() u64 {
	mut lines := read_day('day18.txt')
	mut result := u64(0)
	for line in lines {
		mut ls := d18_string_calculate(line, true)
		result += ls
	}
	return result
}
