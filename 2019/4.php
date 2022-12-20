<?php

function CalcPass($Input, $Mode = 'Classic') {
    $SplitRange = explode("-", $Input);

    $From = (int) $SplitRange[0];
    $To   = (int) $SplitRange[1];
    $Result = 0;

    foreach ( range($From, $To) as $Number ) {
        $SplitNumber = str_split($Number);

        $Increasing            = 1;
        $AdjacentDigitsList    = [];
        $AdjacentDigitsListElf = [];
        $AdjacentDigits = 0;
        $PrevChar = -1;
        foreach ($SplitNumber as $Key => $Char) {
            if (!isset($AdjacentDigitsList[$Char])) $AdjacentDigitsList[$Char] = 0;
            $AdjacentDigitsList[$Char]++;

            if ( $AdjacentDigitsList[$Char] > 1 ) {
                $AdjacentDigits = 1;
            }

            if ( $PrevChar == $Char ) {
                if (!isset($AdjacentDigitsListElf[$Char])) $AdjacentDigitsListElf[$Char] = 1;
                $AdjacentDigitsListElf[$Char]++;
            }

            if ( $PrevChar <= $Char ) {
                $PrevChar = $Char;
                continue;
            }

            $Increasing = 0;

            break;
        }

        if (!$Increasing) continue;

        if ($Mode && $Mode == 'Elf') {

            $AdjacentDigits = 0;
            CHAR:
            foreach ($AdjacentDigitsListElf as $Char => $Value) {
                if ($Value != 2) continue;

                $AdjacentDigits = 1;

                break;
            }
        }

        if (!$AdjacentDigits) continue;

        $Result++;
    }

    return $Result;
}

$Count = CalcPass('146810-612564');

print "Part 1: $Count\n";

$Count = CalcPass('146810-612564', 'Elf');

print "Part 2: $Count\n";

?>