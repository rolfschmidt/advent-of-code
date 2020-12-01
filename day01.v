module main

fn day01a() int {
    numbers := read_day('day01.txt').map(it.int())
    mut result := 0

    for number1 in numbers {
        for number2 in numbers {
            if number1 + number2 == 2020 {
                result = number1 * number2
                break
            }
        }

        if result > 0 {
            break
        }
    }

    return result
}

fn day01b() int {
    numbers := read_day('day01.txt').map(it.int())
    mut result := 0

    for number1 in numbers {
        for number2 in numbers {
            for number3 in numbers {
                if number1 + number2 + number3 == 2020 {
                    result = number1 * number2 * number3
                    break
                }
            }

            if result > 0 {
                break
            }
        }

        if result > 0 {
            break
        }
    }

    return result
}