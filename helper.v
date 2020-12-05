module main

import os
import regex

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

fn regex_match(value string, query string) []string {
	mut re := regex.regex_opt(query) or { panic(err) }
	start, end := re.match_string(value)
	mut result := []string{}
	if start != -1 {
		result << value[start..end]
	}
	for gi := 0; gi < re.groups.len; gi += 2 {
		if re.groups[gi] == -1 {
			result << ''
			continue
		}
		result << value[re.groups[gi]..re.groups[gi + 1]]
	}
	return result
}
