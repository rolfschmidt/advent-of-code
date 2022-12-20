module main

fn day01a() int {
	numbers := read_day('day01.txt').map(it.int())
	for number1 in numbers {
		for number2 in numbers {
			if number1 + number2 == 2020 {
				return number1 * number2
			}
		}
	}
	return 0
}

fn day01b() int {
	numbers := read_day('day01.txt').map(it.int())
	for number1 in numbers {
		for number2 in numbers {
			for number3 in numbers {
				if number1 + number2 + number3 == 2020 {
					return number1 * number2 * number3
				}
			}
		}
	}
	return 0
}
