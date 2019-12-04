#/usr/bin/perl

use strict;
use warnings;

use List::Util qw(max sum);

sub CalcPass {
    my ($Input) = @_;

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
        my $AdjacentDigits;
        my $PrevChar;
        SPLIT:
        for my $Char (@SplitNumber) {
            $AdjacentDigitsList{$Char} ||= 0;
            $AdjacentDigitsList{$Char}++;

            if ( $AdjacentDigitsList{$Char} > 1 ) {
                $AdjacentDigits = 1;
            }


            if ( !defined$PrevChar || ($PrevChar && $PrevChar <= $Char) ) {
                $PrevChar = $Char;
                next SPLIT;
            }

            $Increasing = 0;

            last SPLIT;
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


1;