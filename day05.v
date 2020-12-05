module main

fn partionate(code string, range_low_init int, range_high_init int, index int) int {
	mut range_low := range_low_init
	mut range_high := range_high_init
	if index > code.len - 1 {
		if code[index - 1] == `F` || code[index - 1] == `L` {
			return range_low
		} else {
			return range_high
		}
	}
	typ := code[index]
	if typ == `F` || typ == `L` {
		range_high = range_high - ((range_high + 1 - range_low) / 2)
	} else if typ == `B` || typ == `R` {
		range_low = (range_high + 1 - range_low) / 2 + range_low
	}
	return partionate(code, range_low, range_high, index + 1)
}

fn d5_seats(seat_data []string) []int {
	mut result := []int{}
	for seat_string in seat_data {
		column := partionate(seat_string[0..seat_string.len - 3], 0, 127, 0)
		row := partionate(seat_string[seat_string.len - 3..seat_string.len], 0, 7, 0)
		result << column * 8 + row
	}
	return result
}

fn day05a() int {
	seat_data := read_day('day05.txt')
	mut seats := d5_seats(seat_data)
	seats.sort()
	return seats.last()
}

fn day05b() int {
	seat_data := read_day('day05.txt')
	mut seats := d5_seats(seat_data)
	seats.sort()
	mut seat := 0
	for i := 0; i < seats.len; i++ {
		seat = seats[i]
		if seats[i + 1] != seat + 1 {
			break
		}
	}
	return seat + 1
}
