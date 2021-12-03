package helper

import (
    "os"
    "bufio"
    "math"
    "strconv"
)

func ReadFile(path string) []string {
    file, err := os.Open(path)
	if err != nil {
		panic(err.Error() + `: ` + path)
	}
    defer file.Close()

	var result []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		result = append(result, string(scanner.Text()))
	}

	return result
}

func String2Int(value string) int {
    result, _ := strconv.Atoi(value)
    return result
}

func String2Int64(value string) int64 {
	result, _ := strconv.ParseInt(value, 10, 64)
	return result
}

func StringArray2Int64Array(strings []string) []int64 {
	var result []int64
	for _, value := range strings {
		result = append(result, String2Int64(value))
	}
	return result
}

func Binary2Decimal(number int) int {
    decimal := 0
    counter := 0.0
    remainder := 0

    for number != 0 {
        remainder = number % 10
        decimal += remainder * int(math.Pow(2.0, counter))
        number = number / 10
        counter++
    }
    return decimal
}

func Int64Min(vars ...int64) int64 {
    min := vars[0]

    for _, i := range vars {
        if min > i {
            min = i
        }
    }

    return min
}

func Int64Max(vars ...int64) int64 {
    min := vars[0]

    for _, i := range vars {
        if min < i {
            min = i
        }
    }

    return min
}