module main

fn test_d18_calculate() {
    assert d18_string_calculate('1 + (2 * 3) + (4 * (5 + 6))', false) == 51
    assert d18_string_calculate('2 * 3 + (4 * 5)', false) == 26
    assert d18_string_calculate('5 + (8 * 3 + 9 + 3 * 4 * 3)', false) == 437
    assert d18_string_calculate('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))', false) == 12240
    assert d18_string_calculate('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', false) == 13632
    assert d18_string_calculate('1 + (2 * 3) + (4 * (5 + 6))', true) == 51
    assert d18_string_calculate('2 * 3 + (4 * 5)', true) == 46
    assert d18_string_calculate('5 + (8 * 3 + 9 + 3 * 4 * 3)', true) == 1445
    assert d18_string_calculate('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))', true) == 669060
    assert d18_string_calculate('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', true) == 23340
}

fn test_day18a() {
	assert day18a() == 21022630974613
}

fn test_day18b() {
	assert day18b() == 169899524778212
}
