#/usr/bin/perl

use strict;
use warnings;

my $Compute = sub {
    my ($Code) = @_;

    my @Parts = split /,/, $Code;

    my $Index = 0;
    PART:
    while ( $Index != 99 ) {
        my $Part = int $Parts[$Index];

        last PART if $Part == 99;

        my $Result;
        if ( $Part == 1 ) {
            $Result = $Parts[ $Parts[ $Index + 1 ] ] + $Parts[ $Parts[ $Index + 2 ] ];
        }
        elsif ( $Part == 2 ) {
            $Result = $Parts[ $Parts[ $Index + 1 ] ] * $Parts[ $Parts[ $Index + 2 ] ];
        }

        $Parts[ $Parts[ $Index + 3 ] ] = $Result;
        $Index += 4;
    }

    return join ',', @Parts;
};

my @Tests = (
    {
        Code   => '1,0,0,0,99',
        Result => '2,0,0,0,99',
        Text   => '1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2)',
    },
    {
        Code   => '2,3,0,3,99',
        Result => '2,3,0,6,99',
        Text   => '2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).',
    },
    {
        Code   => '2,4,4,5,99,0',
        Result => '2,4,4,5,99,9801',
        Text   => '2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).',
    },
    {
        Code   => '1,1,1,4,99,5,6,0,99',
        Result => '30,1,1,4,2,5,6,0,99',
        Text   => '1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.',
    },
    {
        Code   => '1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,6,23,27,1,27,5,31,2,9,31,35,1,5,35,39,2,6,39,43,2,6,43,47,1,5,47,51,2,9,51,55,1,5,55,59,1,10,59,63,1,63,6,67,1,9,67,71,1,71,6,75,1,75,13,79,2,79,13,83,2,9,83,87,1,87,5,91,1,9,91,95,2,10,95,99,1,5,99,103,1,103,9,107,1,13,107,111,2,111,10,115,1,115,5,119,2,13,119,123,1,9,123,127,1,5,127,131,2,131,6,135,1,135,5,139,1,139,6,143,1,143,6,147,1,2,147,151,1,151,5,0,99,2,14,0,0',
        Result => '4484226',
        Text   => 'puzzle',
    },
);

TEST:
for my $Test (@Tests) {

    my $Result = $Compute->($Test->{Code});
    if ( $Result =~ $Test->{Result} ) {
        print "ok " . $Test->{Text} . " (Result: " . $Test->{Result} . ")\n";
    }
    else {
        print "failed " . $Test->{Text} . " " . $Test->{Result} . " != $Result\n";
    }
}

#
# PART 2
#

print "\nPART2\n\n";

my $Code = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,6,23,27,1,27,5,31,2,9,31,35,1,5,35,39,2,6,39,43,2,6,43,47,1,5,47,51,2,9,51,55,1,5,55,59,1,10,59,63,1,63,6,67,1,9,67,71,1,71,6,75,1,75,13,79,2,79,13,83,2,9,83,87,1,87,5,91,1,9,91,95,2,10,95,99,1,5,99,103,1,103,9,107,1,13,107,111,2,111,10,115,1,115,5,119,2,13,119,123,1,9,123,127,1,5,127,131,2,131,6,135,1,135,5,139,1,139,6,143,1,143,6,147,1,2,147,151,1,151,5,0,99,2,14,0,0";
my $CodeIndex = scalar(split(/,/, $Code)) - 1;

NUM1:
for my $Number1 (0 .. $CodeIndex) {

    NUM2:
    for my $Number2 (0 .. $CodeIndex) {

        my @SplitCode = split /,/, $Code;

        $SplitCode[1] = $Number1;
        $SplitCode[2] = $Number2;

        my $NewCode = join ',', @SplitCode;

        my $Result = $Compute->($NewCode);
        my @SplitResult = split /,/, $Result;

        next NUM2 if $SplitResult[0] != 19690720;

        print "Find the input noun and verb that cause the program to produce the output 19690720.\n";

        print "Number1: $Number1 \n";
        print "Number2: $Number2 \n";

        last NUM1;
    }
}

1;