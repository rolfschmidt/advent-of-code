module main

import os
import regex

fn read_day(path string) []string {
	mut data := os.read_file(path) or {
		panic(err)
	}
	return data.trim(' \n\t\v\f\r').split('\n')
}

fn regex_match(value string, query string) []string {
	mut re := regex.regex_opt(query) or {
		panic(err)
	}
	re.match_string(value)
	mut result := []string{}
	for gi := 0; gi < re.groups.len; gi += 2 {
		result << '${value[re.groups[gi]..re.groups[gi + 1]]}'
	}
	return result
}
