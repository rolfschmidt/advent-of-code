package helper

import (
    "os"
    "bufio"
    "math"
    "sort"
    "strings"
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
    	result = append(result, Trim(string(scanner.Text())))
	}

	return result
}

func ReadFileString(path string) string {
    file, err := os.Open(path)
    if err != nil {
        panic(err.Error() + `: ` + path)
    }
    defer file.Close()

    var result string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        result = result + string(scanner.Text()) + "\n"
    }

    return Trim(result)
}

func StringArrayInt(strings []string) []int {
    var result []int
    for _, value := range strings {
        result = append(result, String2Int(value))
    }
    return result
}

func Int2String(value int) string {
    return strconv.Itoa(value)
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

func IntMin(vars ...int) int {
    min := vars[0]

    for _, i := range vars {
        if min > i {
            min = i
        }
    }

    return min
}

func IntMax(vars ...int) int {
    min := vars[0]

    for _, i := range vars {
        if min < i {
            min = i
        }
    }

    return min
}

func StringArraySelect(arr []string, filter func(string) bool) string {
    for _, value := range arr {
        if filter(value) {
            return value
        }
    }
    return ""
}

func StringArrayPop(arr []string) (string, []string) {
    return arr[len(arr) - 1], arr[:len(arr) - 1]
}

func StringSort(word string) string {
    s := []rune(word)
    sort.Slice(s, func(i int, j int) bool { return s[i] < s[j] })
    return string(s)
}

func Split(value string, delimiter string) []string {
    return strings.Split(value, delimiter)
}

func Join(value []string, delimiter string) string {
    return strings.Join(value[:], delimiter)
}

func Trim(value string) string {
    return strings.TrimSpace(value)
}
