#/usr/bin/perl

use strict;
use warnings;

sub CalcPass {
    my ($Input, $Mode) = @_;

    my @SplitRange = split /-/, $Input;

    my $From = int $SplitRange[0];
    my $To   = int $SplitRange[1];
    my $Result = 0;

    NUMBER:
    for my $Number ($From .. $To) {
        my @SplitNumber = split //, $Number;

        # check two adjacent digits
        my $Increasing = 1;
        my %AdjacentDigitsList;
        my %AdjacentDigitsListElf;
        my $AdjacentDigits;
        my $PrevChar = -1;
        SPLIT:
        for my $Char (@SplitNumber) {
            $AdjacentDigitsList{$Char} ||= 0;
            $AdjacentDigitsList{$Char}++;

            if ( $AdjacentDigitsList{$Char} > 1 ) {
                $AdjacentDigits = 1;
            }

            if ( $PrevChar eq $Char ) {
                $AdjacentDigitsListElf{$Char} ||= 1;
                $AdjacentDigitsListElf{$Char}++;
            }

            if ( $PrevChar <= $Char ) {
                $PrevChar = $Char;
                next SPLIT;
            }

            $Increasing = 0;

            last SPLIT;
        }

        if ($Mode && $Mode eq 'Elf') {

            $AdjacentDigits = 0;
            CHAR:
            for my $Char (sort keys %AdjacentDigitsListElf) {
                next CHAR if $AdjacentDigitsListElf{$Char} != 2;

                $AdjacentDigits = 1;

                last CHAR;
            }
        }

        next NUMBER if !$Increasing;
        next NUMBER if !$AdjacentDigits;

        $Result++;
    }

    return $Result;
}

my $Count = CalcPass('146810-612564');
die "Count failed for puzzle range" if scalar $Count != 1748;

print "Part 1: $Count\n";

$Count = CalcPass('146810-612564', 'Elf');
die "Count failed for puzzle range $Count" if scalar $Count != 1180;

print "Part 2: $Count\n";

1;