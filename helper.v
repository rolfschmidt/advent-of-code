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
    r := regex.new_regex(query, 0) or { return [] }
    m := r.match_str(value, 0, 0) or { return [] }
    mut result := []string{}
    for i := 0; i < m.group_size; i++ {
        match_value := m.get(i) or { '' }
        result << match_value
    }
    r.free()
    return result
}
