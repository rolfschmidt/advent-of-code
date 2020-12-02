module main

import regex

struct D2Password {
mut:
    min_char int
    max_char int
    check_char string
    check_string string
}

fn (p D2Password) valid() bool {
    return p.check_string.count(p.check_char) >= p.min_char && p.check_string.count(p.check_char) <= p.max_char
}

fn (p D2Password) valid_by_index() bool {
    match_min := p.check_string.substr(p.min_char - 1, p.min_char) == p.check_char
    match_max := p.check_string.substr(p.max_char - 1, p.max_char) == p.check_char

    return (!match_min && match_max) || (match_min && !match_max)
}

fn d2_parse_password(password string) D2Password {
    query := r"([0-9]+)\-([0-9]+)\s(\w+):\s(\w+)"
    mut re := regex.regex_opt(query) or { panic(err) }
    re.match_string(password)

    mut min_char     := 0
    mut max_char     := 0
    mut check_char   := ''
    mut check_string := ''

    mut gi := 0
    for gi < re.groups.len {
        if gi == 0 {
            min_char = "${password[re.groups[gi]..re.groups[gi+1]]}".int()
        }
        else if gi == 2 {
            max_char = "${password[re.groups[gi]..re.groups[gi+1]]}".int()
        }
        else if gi == 4 {
            check_char = "${password[re.groups[gi]..re.groups[gi+1]]}"
        }
        else if gi == 6 {
            check_string = "${password[re.groups[gi]..re.groups[gi+1]]}"
        }
        gi += 2
    }

    return D2Password {
        min_char: min_char
        max_char: max_char
        check_char: check_char
        check_string: check_string
    }
}

fn day02a() int {
    mut valid_count := 0

    passwords := read_day('day02.txt')
    for password in passwords {
        pass_obj := d2_parse_password(password)
        if !pass_obj.valid() {
            continue
        }

        valid_count++
    }

    return valid_count
}

fn day02b() int {
    mut valid_count := 0

    passwords := read_day('day02.txt')
    for password in passwords {
        pass_obj := d2_parse_password(password)
        if !pass_obj.valid_by_index() {
            continue
        }

        valid_count++
    }

    return valid_count
}