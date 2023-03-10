module main

import os
import pcre

fn read_day_string(path string) string {
	mut data := os.read_file(path) or { panic(err) }
	return data.trim(' \n\t\v\f\r')
}

fn read_day(path string) []string {
	return read_day_string(path).split_into_lines()
}

// returns a array of the regex matched strings
fn regex_match(value string, query string) []string {
	r := pcre.new_regex(query, 0) or { panic('err $err - value $value - query $query') }
	m := r.match_str(value, 0, 0) or { return [] }
	mut result := []string{}
	for i := 0; i < m.group_size; i++ {
		match_value := m.get(i) or { '' }
		result << match_value
	}
	r.free()
	return result
}

// returns a array of the string splitted by the regex
fn regex_split(value string, query string) []string {
	mut result := []string{}
	mut match_string := value
	for {
		groups := regex_match(match_string, query)
		if groups.len == 0 {
			break
		}
		index := match_string.index(groups[0]) or { 0 }
		result << match_string[0..index + groups[0].len]
		match_string = match_string[index + groups[0].len..]
	}
	if result.len > 0 && match_string.len > 0 {
		result << match_string
	}
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
	for value in arr {
		if value > high {
			high = value
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

// returns min value of int
fn int_min(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

// returns max value of int
fn int_max(a int, b int) int {
	if a > b {
		return a
	}
	return b
}

// returns a list of indexes of the array
fn aint_index(arr []int) []int {
	mut result := []int{}
	for i in 0 .. arr.len {
		result << i
	}
	return result
}

// returns min value of array int
fn aint_min(arr []int) int {
	mut low := int(0)
	mut found := false
	for value in arr {
		if value < low || !found {
			low = value
			found = true
		}
	}
	return low
}

// returns max value of array int
fn aint_max(arr []int) int {
	mut high := int(0)
	for value in arr {
		if value > high {
			high = value
		}
	}
	return high
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
fn string_flip(value string, a string, b string) string {
	if value == a {
		return b
	} else if value == b {
		return a
	}
	return value
}

// returns the 2d array flattend
fn astring_flatten(arr [][]string) []string {
	mut result := []string{}
	for v in arr {
		for sv in v {
			result << sv
		}
	}
	return result
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

// returns a decimal number out of binary number
// Big thanks to @JalonSolov
fn bindec(b string) u64 {
	mut i := u64(0)
	for idx in b {
		i = i << 1
		if idx == `1` {
			i++
		}
	}
	return i
}

// returns binary number out of decimal number
// Big thanks to @JalonSolov
fn decbin(n u64, length u64) string {
	mut s := ''
	mut u := n
	for u > 0 {
		s += if u & 1 == 1 { '1' } else { '0' }
		u = u >> 1
	}
	if length > 0 {
		for s.len < length {
			s += '0'
		}
	}
	return s.reverse()
}
