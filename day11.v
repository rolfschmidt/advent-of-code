module main

fn seat_pos(lines [][]string, x int, y int) bool {
	if !astr_valid_index(lines[0], x) || !aastr_valid_index(lines, y) {
		return false
	}
	return lines[y][x] == 'L'
}

fn occupied_pos(lines [][]string, x int, y int) bool {
	if !astr_valid_index(lines[0], x) || !aastr_valid_index(lines, y) {
		return false
	}
	return lines[y][x] == '#'
}

fn toggle_occupied(lines [][]string, occupied_range int, x int, y int) bool {
	mut count := 0
	if occupied_range == 5 {
		mut ranges := [][][]int{}
		maxx := lines[x].len
		maxy := lines.len
		// left
		ranges << aint_range(x - 1, 0).map([it, y])
		// right
		ranges << aint_range(x + 1, maxx).map([it, y])
		// top
		ranges << aint_range(y - 1, 0).map([x, it])
		// bottom
		ranges << aint_range(y + 1, maxy).map([x, it])
		// left top
		ranges << aint_diagonal_range(x - 1, y - 1, 0, 0)
		// right top
		ranges << aint_diagonal_range(x + 1, y - 1, maxx, 0)
		// left bottom
		ranges << aint_diagonal_range(x - 1, y + 1, 0, maxy)
		// right bottom
		ranges << aint_diagonal_range(x + 1, y + 1, maxx, maxy)
		for rr in ranges {
			for pos in rr {
				if pos[0] == x && pos[1] == y {
					continue
				}
				if seat_pos(lines, pos[0], pos[1]) {
					break
				}
				if occupied_pos(lines, pos[0], pos[1]) {
					count++
					break
				}
			}
		}
	} else {
		mut range := [-1, 0, 1]
		mut coords := [][]int{}
		for val1 in range {
			for val2 in range {
				if val1 == 0 && val2 == 0 {
					continue
				}
				coords << [x + val1, y + val2]
			}
		}
		for pos in coords {
			if occupied_pos(lines, pos[0], pos[1]) {
				count++
			}
		}
	}
	return (lines[y][x] == 'L' && count == 0) || (lines[y][x] == '#' && count >= occupied_range)
}

fn d11_run(mut lines [][]string, occupied_range int) int {
	mut counter := 0
	for {
		mut changes := [][]int{}
		for y, line in lines {
			for x, _ in line {
				toggle := toggle_occupied(lines, occupied_range, x, y)
				if toggle {
					changes << [x, y]
				}
			}
		}
		for p in changes {
			lines[p[1]][p[0]] = str_flip(lines[p[1]][p[0]], '#', 'L')
		}
		if changes.len < 1 {
			break
		}
		counter++
	}
	return aastring_count('#', lines)
}

fn day11a() int {
	mut lines := read_day('day11.txt').map(it.split(''))
	return d11_run(mut lines, 4)
}

fn day11b() int {
	mut lines := read_day('day11.txt').map(it.split(''))
	return d11_run(mut lines, 5)
}
