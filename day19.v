module main

fn d19_get_rule(rules map[string]string, pos int, crule string, search string) string {
	if rules[pos.str()].contains('"') {
		return rules[pos.str()][1].str()
	}
	mut rule := '(?:'
	if pos == 0 {
		rule = '^(?:'
	}
	for ch in rules[pos.str()].split(' ') {
		mut groups := regex_match(ch, r'^\d+(.*)?$')
		if groups.len > 0 {
			rule += d19_get_rule(rules, ch.int(), crule + rule, search)
			if groups[1].len > 0 {
				rule += groups[1]
			}
		} else if ch == '|' {
			rule += '|'
		}
	}
	if pos == 0 {
		rule += ')$'
	} else {
		rule += ')'
	}
	return rule
}

fn day19a() int {
	mut lines := read_day_string('day19.txt')
	data := lines.split('\n\n')
	mut rules := map[string]string{}
	for line in data[0].split('\n') {
		rules[line.all_before(': ')] = line.all_after(': ')
	}
	regex := d19_get_rule(rules, 0, '', '')
	mut count := 0
	for value in data[1].split('\n') {
		if regex_match(value, regex).len > 0 {
			count++
		}
	}
	return count
}

fn day19b() int {
	mut lines := read_day_string('day19.txt')
	data := lines.split('\n\n')
	mut rules := map[string]string{}
	for line in data[0].split('\n') {
		rules[line.all_before(': ')] = line.all_after(': ')
	}
	rules['8'] = '42+'
	rules['11'] = '42 31 | 42{2} 31{2} | 42{3} 31{3} | 42{4} 31{4} | 42{5} 31{5}'
	regex := d19_get_rule(rules, 0, '', '')
	mut count := 0
	for value in data[1].split('\n') {
		if regex_match(value, regex).len > 0 {
			count++
		}
	}
	return count
}
