module main

fn d8_replace_run(from string, to string, lines []string, index int) int {
	mut sub_lines := lines.clone()
	sub_lines[index] = sub_lines[index].replace(from, to)
	return d8_run(sub_lines, true, false)
}

fn d8_run(acc_lines []string, return_seen bool, bruteforce bool) int {
	mut result := 0
	mut seen := map[string]bool{}
	for i := 0; i < acc_lines.len; i++ {
		if seen[i.str()] {
			if return_seen {
				return -1
			}
			break
		}
		line := acc_lines[i].str()
		command := line[..3]
		operator := line[4].ascii_str()
		value := line[5..].int()
		seen[i.str()] = true
		if bruteforce && ['jmp', 'nop'].contains(command) {
			to := command.replace_each(['jmp', 'nop', 'nop', 'jmp'])
			sub_result := d8_replace_run(command, to, acc_lines, i)
			if sub_result != -1 {
				result = sub_result
				break
			}
		}
		if command == 'nop' {
			continue
		} else if command == 'acc' {
			if operator == '+' {
				result += value
			} else {
				result -= value
			}
		} else if command == 'jmp' {
			if operator == '+' {
				i += value - 1
			} else {
				i -= value + 1
			}
		}
	}
	return result
}

fn day08a() int {
	acc_lines := read_day('day08.txt')
	return d8_run(acc_lines, false, false)
}

fn day08b() int {
	acc_lines := read_day('day08.txt')
	return d8_run(acc_lines, false, true)
}
