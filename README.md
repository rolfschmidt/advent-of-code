# Advent of Code

<a href="http://www.adventofcode.com" target="_blank"><img width="700" alt="image" src="https://github.com/user-attachments/assets/8252cdba-9787-464e-aac3-ab422541abe9" /></a>


|  Year  |  Progress   |  Language(s)  |
|:------:|:-----------:|:-------------:|
|  2025  |     3/12    | Ruby          |
|  2024  |    25/25    | Ruby          |
|  2023  |    25/25    | Ruby          |
|  2022  |    25/25    | Ruby          |
|  2021  |    25/25    | Go            |
|  2020  |    25/25    | V             |
|  2019  |     8/25    | Perl <br> day 4 in Perl, Python, PHP, JS, Rust, C++ and Ruby |
|  2018  |    11/25    | Ruby          |
|  2017  |    25/25    | Ruby          |
|  2016  |     0/25    | -             |
|  2015  |    25/25    | Ruby          |

## Bash alias

Helpful aliases for advent of code handling:

```
npm install -g nodemon

alias aoc='f() { nodemon -q -e rb -w /home/debian-rs/ws/advent-of-code -x "bundle exec rspec --fail-fast spec/day${1}_spec.rb"; }; f'
alias aoc-new='f() { local F="spec/day${1}_spec.rb"; cp "spec/day00_spec.rb" "${F}"; touch "spec/day${1}_test.txt"; sed -i "s/Day00/Day${1}/g" "${F}"; }; f'
```
