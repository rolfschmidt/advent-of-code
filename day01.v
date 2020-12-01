module main

fn day01a() int {
    numbers := read_day('day01.txt')
    mut result := 0

    for number1 in numbers {
        for number2 in numbers {
            if ( number1.int() + number2.int() ) == 2020 {
                result = number1.int() * number2.int()
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
    numbers := read_day('day01.txt')
    mut result := 0

    for number1 in numbers {
        for number2 in numbers {
            for number3 in numbers {
                if ( number1.int() + number2.int() + number3.int() ) == 2020 {
                    result = number1.int() * number2.int() * number3.int()
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