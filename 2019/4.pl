#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

my @Data;
my $Index = 0;
while (<DATA>) {
    if ( $_ =~ m{\A\s*\z} ) {
        $Index++;
        next;
    }
    $Data[$Index] ||= '';
    $Data[$Index] .= $_;
};

sub CalcPass {
    my ($Input, $Mode) = @_;

    my @SplitRange = split /-/, $Input;

    my $From = int $SplitRange[0];
    my $To   = int $SplitRange[1];
    my $Result = 0;

    NUMBER:
    for my $Number ($From .. $To) {
        my @SplitNumber = split //, $Number;

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

        next NUMBER if !$Increasing;

        if ($Mode && $Mode eq 'Elf') {

            $AdjacentDigits = 0;
            CHAR:
            for my $Char (sort keys %AdjacentDigitsListElf) {
                next CHAR if $AdjacentDigitsListElf{$Char} != 2;

                $AdjacentDigits = 1;

                last CHAR;
            }
        }

        next NUMBER if !$AdjacentDigits;

        $Result++;
    }

    return $Result;
}

my $Count = CalcPass($Data[0]);
is($Count, 1748, "Part 1 - Puzzle (Result: $Count)");

$Count = CalcPass($Data[0], 'Elf');
is($Count, 1180, "Part 2 - Puzzle (Result: $Count)");

done_testing();

1;

__DATA__
146810-612564