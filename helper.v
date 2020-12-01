module main

import os

fn read_day(path string) []string {
    mut data := os.read_file(path) or {
        panic(err)
    }

    data = data.trim(' \n\t\v\f\r')

    return data.split('\n')
}