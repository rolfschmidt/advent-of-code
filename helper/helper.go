package helper

import (
    "os"
    "bufio"
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