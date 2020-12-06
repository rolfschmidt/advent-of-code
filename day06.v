module main

fn d6_parse_questions(question_data string) (int, int) {
	mut everyone_yes := 0
	mut all_yes := 0
	for block in question_data.split('\n\n') {
		persons := block.count('\n') + 1
		mut yes := map[string]int{}
		for question in block.replace('\n', '') {
			yes[question.str()]++
		}
		everyone_yes += yes.keys().map(yes[it]).len
		all_yes += yes.keys().filter(yes[it] == persons).len
	}
	return everyone_yes, all_yes
}

fn day06a() int {
	question_data := read_day_string('day06.txt')
	everyone_yes, _ := d6_parse_questions(question_data)
	return everyone_yes
}

fn day06b() int {
	question_data := read_day_string('day06.txt')
	_, all_yes := d6_parse_questions(question_data)
	return all_yes
}
