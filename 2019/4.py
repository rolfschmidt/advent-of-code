
def calcpass(input, mode = 'classic'):
    splitrange = input.split('-')

    fromx = int(splitrange[0])
    to   = int(splitrange[1])
    result = 0

    for number in range(fromx, to):
        splitnumber = list(str(number))

        increasing            = 1
        adjacentdigitslist    = {}
        adjacentdigitslistelf = {}
        adjacentdigits = 0
        prevchar = -1
        for char in splitnumber:
            char = int(char)

            if char not in adjacentdigitslist:
                adjacentdigitslist[char] = 0
            adjacentdigitslist[char] += 1

            if adjacentdigitslist[char] > 1:
                adjacentdigits = 1

            if prevchar == char:
                if char not in adjacentdigitslistelf:
                    adjacentdigitslistelf[char] = 1
                adjacentdigitslistelf[char] += 1

            if prevchar <= char:
                prevchar = char
                continue

            increasing = 0

            break

        if increasing == 0:
            continue

        if mode == 'elf':

            adjacentdigits = 0
            for value in adjacentdigitslistelf.values():
                if value != 2:
                    continue

                adjacentdigits = 1

                break

        if adjacentdigits == 0:
            continue

        result += 1

    return result

count = calcpass('146810-612564', 'classic')

print("part 1: " + str(count))

count = calcpass('146810-612564', 'elf')

print("part 2: " + str(count))

