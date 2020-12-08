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
    r := regex.new_regex(query, 0) or {
        return []
    }

    m := r.match_str(value, 0, 0) or {
        return []
    }

    mut result := []string{}
    mut match_index := 0
    for {
        match_value := m.get(match_index) or {
            break
        }

        result << match_value
        match_index++
    }

    r.free()

    return result
}
