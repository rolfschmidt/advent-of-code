use std::collections::HashMap;

fn calcpass(input: &str, mode: &str) -> usize {

    let splitrange: Vec<&str> = input.split("-").collect();
    let from: usize           = splitrange[0].parse().unwrap();
    let to: usize             = splitrange[1].parse().unwrap();
    let mut result: usize     = 0;

    for number in from .. to {
        let number_str                 = number.to_string();
        let mut splitnumber: Vec<&str> = number_str.split("").collect();
        splitnumber.pop();
        splitnumber.drain(0 .. 1);

        let mut increasing                                  = 1;
        let mut adjacentdigitslist: HashMap<&str, usize>    = HashMap::new();
        let mut adjacentdigitslistelf: HashMap<&str, usize> = HashMap::new();
        let mut adjacentdigits                              = 0;
        let mut prevchar                                    = 0;

        for char in splitnumber {
            let char_number: usize = char.parse().unwrap();
            adjacentdigitslist.entry(char).or_insert(0);
            adjacentdigitslist.insert(char, adjacentdigitslist[char] + 1);

            if adjacentdigitslist[char] > 1 {
                adjacentdigits = 1;
            }

            if prevchar == char_number {
                adjacentdigitslistelf.entry(char).or_insert(1);
                adjacentdigitslistelf.insert(char, adjacentdigitslistelf[char] + 1);
            }

            if prevchar <= char_number {
                prevchar = char_number;
                continue;
            }

            increasing = 0;

            break;
        }

        if increasing <= 0 { continue; }

        if mode == "elf" {

            adjacentdigits = 0;
            for char in adjacentdigitslistelf.keys() {
                if adjacentdigitslistelf[char] != 2 { continue; }

                adjacentdigits = 1;

                break;
            }
        }

        if adjacentdigits <= 0 { continue; }

        result += 1;
    }

    return result;
}

fn main() {
    let count = calcpass("146810-612564", "classic");

    println!("Part 1: {:?}", count);

    let count = calcpass("146810-612564", "elf");

    println!("Part 2: {:?}", count);
}
