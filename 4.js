function range(start, end) {
    var ans = [];
    for (let i = start; i <= end; i++) {
        ans.push(i);
    }
    return ans;
}

function CalcPass(Input, Mode = 'Classic') {
    SplitRange = Input.split("-");

    var From = Number(SplitRange[0]);
    var To   = Number(SplitRange[1]);
    var Result = 0;

    range(From, To).forEach(function(NumberStr) {
        SplitNumber = NumberStr.toString().split("");

        var Increasing            = 1;
        var AdjacentDigitsList    = {};
        var AdjacentDigitsListElf = {};
        var AdjacentDigits = 0;
        var PrevChar = -1;
        SplitNumber.forEach(function(Char) {
            if (typeof AdjacentDigitsList[Char] == 'undefined') AdjacentDigitsList[Char] = 0;
            AdjacentDigitsList[Char]++;

            if ( AdjacentDigitsList[Char] > 1 ) {
                AdjacentDigits = 1;
            }

            if ( PrevChar == Char ) {
                if (typeof AdjacentDigitsListElf[Char] == 'undefined') AdjacentDigitsListElf[Char] = 1;
                AdjacentDigitsListElf[Char]++;
            }

            if ( PrevChar <= Char ) {
                PrevChar = Char;
                return true;
            }

            Increasing = 0;

            return false;
        });

        if (!Increasing) return true;

        if (Mode && Mode == 'Elf') {

            AdjacentDigits = 0;
            CHAR:
            Object.keys(AdjacentDigitsListElf).forEach(function(Key) {
                Value = AdjacentDigitsListElf[Key];
                if (Value != 2) return true;

                AdjacentDigits = 1;

                return false;
            });
        }

        if (!AdjacentDigits) return true;

        Result++;
    });

    return Result;
}

Count = CalcPass('146810-612564');

console.log("Part 1: " + Count + "\n");

Count = CalcPass('146810-612564', 'Elf');

console.log("Part 2: " + Count + "\n");
