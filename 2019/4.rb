
def calcpass(input, mode = 'classic')
    splitrange = input.split('-')

    from = splitrange[0].to_i
    to   = splitrange[1].to_i
    result = 0

    (from .. to).each do |number|
        splitnumber = number.to_s.split('')

        increasing            = 1
        adjacentdigitslist    = {}
        adjacentdigitslistelf = {}
        adjacentdigits = 0
        prevchar = -1
        splitnumber.each do |char|
            char = char.to_i

            adjacentdigitslist[char] ||= 0
            adjacentdigitslist[char] += 1

            if adjacentdigitslist[char] > 1
                adjacentdigits = 1
            end

            if prevchar == char
                adjacentdigitslistelf[char] ||= 1
                adjacentdigitslistelf[char] += 1
            end

            if prevchar <= char
                prevchar = char
                next
            end

            increasing = 0

            break
        end

        next if increasing == 0

        if mode == 'elf'

            adjacentdigits = 0
            adjacentdigitslistelf.values.each do |value|
                next if value != 2

                adjacentdigits = 1

                break
            end
        end

        next if adjacentdigits == 0

        result += 1
    end

    return result
end

count = calcpass('146810-612564')

print "part 1: #{count}\n"

count = calcpass('146810-612564', 'elf')

print "part 2: #{count}\n"

