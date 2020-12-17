module main

fn d16_run(part2 bool) u64 {
	mut lines := read_day_string('day16.txt').split('\n\n')
	mut classes := map[string][][]int{}
	for class_line in lines[0].split('\n') {
		groups := regex_match(class_line, r'([^:]+):\s(\d+)-(\d+)\sor\s(\d+)-(\d+)')
		classes[groups[1]] = [[groups[2].int(),
			groups[3].int(),
		], [groups[4].int(), groups[5].int()]]
	}
	your := lines[1].all_after('your ticket:\n').split(',').map(it.int())
	nearby_lines := lines[2].all_after('nearby tickets:\n').split('\n')
	mut nearby := [][]int{}
	for line in nearby_lines {
		line_numbers := line.split(',').map(it.int())
		nearby << line_numbers
	}
	mut errors := []int{}
	mut class_matrix := map[string]map[string]map[string]bool{} // [class]->[ticket_index]->[ticket]->true
	for _, row in nearby {
		for ticket_index, ticket in row {
			mut in_range := false
			for class, ranges in classes {
				mut in_class_range := false
				for range in ranges {
					if ticket >= range[0] && ticket <= range[1] {
						in_class_range = true
						in_range = true
						break
					}
				}
				if !class_matrix.exists(class) {
					class_matrix[class] = map[string]map[string]bool{}
				}
				if !class_matrix[class].exists(ticket_index.str()) {
					class_matrix[class][ticket_index.str()] = map[string]bool{}
				}
				if !in_class_range {
					class_matrix[class][ticket_index.str()][ticket.str()] = false
				} else if !class_matrix[class][ticket_index.str()].exists(ticket.str()) {
					class_matrix[class][ticket_index.str()][ticket.str()] = true
				}
			}
			if !in_range {
				errors << ticket
			}
		}
	}
	mut result := u64(aint_sum(errors))
	if part2 {
		mut class_indexes := map[string]int{}
		mut skip_indexes := []int{}
		for class_indexes.keys().len < classes.len {
			for class, tickets in class_matrix {
				mut all_match_indexes := []int{}
				for ticket_index, ticket_matches in tickets {
					if ticket_index.int() !in skip_indexes {
						mut all_match := true
						for ticket, ticket_match in ticket_matches {
							if ticket.int() !in errors {
								if !ticket_match {
									all_match = false
									break
								}
							}
						}
						if all_match {
							all_match_indexes << ticket_index.int()
						}
					}
				}
				if all_match_indexes.len == 1 {
					class_indexes[class] = all_match_indexes[0]
					skip_indexes << all_match_indexes[0]
				}
			}
		}
		result = u64(1)
		for class, index in class_indexes {
			if !class.contains('departure') {
				continue
			}
			result *= u64(your[index])
		}
	}
	return result
}

fn day16a() u64 {
	return d16_run(false)
}

fn day16b() u64 {
	return d16_run(true)
}
