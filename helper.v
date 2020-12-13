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

// https://github.com/spytheman/v-regex
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

// returns product of a u64 array
fn au64_product(arr []u64) u64 {
	mut v := arr[0]
	if arr.len > 1 {
		for i in 1 .. arr.len {
			v *= arr[i]
		}
	}
	return v
}

// returns min value of array u64
fn au64_min(arr []u64) u64 {
	mut low := u64(0)
	mut found := false
	for value in arr {
		if value < low || !found {
			low = value
			found = true
		}
	}
	return low
}

// returns max value of array u64
fn au64_max(arr []u64) u64 {
	mut high := u64(0)
	mut found := false
	for value in arr {
		if value > high {
			high = value
			found = true
		}
	}
	return high
}

// returns sum value of array u64
fn au64_sum(arr []u64) u64 {
	mut result := u64(0)
	for value in arr {
		result += value
	}
	return result
}

// returns sum value of array int
fn aint_sum(arr []int) int {
	mut result := 0
	for value in arr {
		result += value
	}
	return result
}

// returns range from value a to b
fn aint_range(from int, to int) []int {
	mut range := []int{}
	if to > from {
		for i := from; i <= to; i++ {
			if i < 0 {
				break
			}
			range << i
		}
	} else {
		for i := from; i >= to; i-- {
			if i < 0 {
				break
			}
			range << i
		}
	}
	return range
}

// returns diagonal range from value a to b
fn aint_diagonal_range(fromx int, fromy int, tox int, toy int) [][]int {
	mut ranges := [][]int{}
	rangex := aint_range(fromx, tox)
	rangey := aint_range(fromy, toy)
	lasty := rangey.len - 1
	for i, x in rangex {
		if i < 0 || i > lasty {
			break
		}
		if x < 0 || rangey[i] < 0 {
			break
		}
		ranges << [x, rangey[i]]
	}
	return ranges
}

// returns flipped value
fn str_flip(value string, a string, b string) string {
	if value == a {
		return b
	}
	return a
}

// returns count of string in array string
fn astring_count(value string, arr []string) int {
	mut count := 0
	for avalue in arr {
		if avalue == value {
			count++
		}
	}
	return count
}

// returns count of string in array of array strings
fn aastring_count(value string, arr [][]string) int {
	mut count := 0
	for arr1 in arr {
		count += astring_count(value, arr1)
	}
	return count
}
