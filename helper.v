module main

import os
import regex

fn read_day(path string) []string {
	mut data := os.read_file(path) or {
		panic(err)
	}
	return data.trim(' \n\t\v\f\r').split('\n')
}

fn regex_match(value string, query string) []int {
	mut re := regex.regex_opt(query) or {
		panic(err)
	}
	re.match_string(value)
	return re.groups
}
