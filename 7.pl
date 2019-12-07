#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(max);
use Test::More;
use Data::Dumper;

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

sub PartOpCodeGet {
    my ($OpCodeIndex, $Parts) = @_;

    return $Parts->[$OpCodeIndex] if $Parts->[$OpCodeIndex] <= 10;

    my @SplitOpCode = split //, $Parts->[$OpCodeIndex];

    return int( $SplitOpCode[-2] . $SplitOpCode[-1] );
}

sub PartModeGet {
    my ($OpCodeIndex, $PartIndex, $Parts) = @_;

    return 1 if $Parts->[$OpCodeIndex] == 3;
    return 0 if $Parts->[$OpCodeIndex] <= 10;

    my @SplitOpCode = reverse split //, $Parts->[$OpCodeIndex];
    shift(@SplitOpCode);
    shift(@SplitOpCode);

    my $TargetIndex = $PartIndex - ($OpCodeIndex + 1);

    return $SplitOpCode[$TargetIndex] || 0;
}

sub PartValueGet {
    my ($OpCodeIndex, $PartIndex, $Parts) = @_;

    my $Mode = PartModeGet($OpCodeIndex, $PartIndex, $Parts);

    my $Result = $Mode == 0 ? $Parts->[ $Parts->[$PartIndex] ] : $Parts->[$PartIndex];

    return $Result;
}

sub PartValueSet {
    my ($OpCodeIndex, $PartIndex, $Value, $Parts) = @_;

    my $Mode = PartModeGet($OpCodeIndex, $PartIndex, $Parts);

    if ($Mode == 0) {
        $Parts->[ $Parts->[ $PartIndex ] ] = $Value;
    }
    else {
        $Parts->[ $PartIndex ] = $Value;
    }

    return 1;
}

sub Compute {
    my ($Code, $Input, $ReturnAll, $Index) = @_;

    my @Parts = split /,/, $Code;
    my @Outputs;

    if (!defined $Input) {
        $Input = 1;
    }
    if (ref $Input ne 'ARRAY') {
        $Input = [$Input];
    }


    my $InputIndex = $Index ? $#{ $Input } : 0;
    $Index = $Index || 0;

    PART:
    while ( 1 ) {
        my $Part = PartOpCodeGet($Index, \@Parts);
        last PART if $Part == 99;

        my $Result;

        # addition
        if ( $Part == 1 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts) + PartValueGet($Index, $Index + 2, \@Parts);
            PartValueSet($Index, $Index + 3, $Result, \@Parts);

            $Index += 4;
        }

        # multiplication
        elsif ( $Part == 2 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts) * PartValueGet($Index, $Index + 2, \@Parts);
            PartValueSet($Index, $Index + 3, $Result, \@Parts);
            $Index += 4;
        }

        # move value
        elsif ( $Part == 3 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts);

            PartValueSet($Index, $Result, defined $Input->[$InputIndex] ? $Input->[$InputIndex] : $Input->[0], \@Parts);
            $InputIndex += 1;
            $Index += 2;
        }

        # print output
        elsif ( $Part == 4 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts);
            push @Outputs, $Result;
            $Index += 2;
            last PART if $ReturnAll;
        }

        # jump if true
        elsif ( $Part == 5 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts);

            if ( $Result == 0 ) {
                $Index += 3;
                next PART;
            }

            $Result = PartValueGet($Index, $Index + 2, \@Parts);
            $Index = $Result;
        }

        # jump if false
        elsif ( $Part == 6 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts);

            if ( $Result != 0 ) {
                $Index += 3;
                next PART;
            }

            $Result = PartValueGet($Index, $Index + 2, \@Parts);
            $Index = $Result;
        }

        # less than
        elsif ( $Part == 7 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts) < PartValueGet($Index, $Index + 2, \@Parts);

            PartValueSet($Index, $Index + 3, $Result ? 1 : 0, \@Parts);

            $Index += 4;
        }

        # equals
        elsif ( $Part == 8 ) {
            $Result = PartValueGet($Index, $Index + 1, \@Parts) == PartValueGet($Index, $Index + 2, \@Parts);

            PartValueSet($Index, $Index + 3, $Result ? 1 : 0, \@Parts);

            $Index += 4;
        }
        else {
            print "Invalid opcode $Part $Index \n";
            last;
        }
    }

    my $ReturnOutputs = join('', @Outputs);
    my $ReturnParts   = join ',', @Parts;

    return {
        Outputs => $ReturnOutputs,
        Parts   => $ReturnParts,
        Index   => $Index,
        Halted   => $Parts[$Index] == 99 ? 1 : 0,
    } if $ReturnAll;

    return $ReturnOutputs if @Outputs;
    return $ReturnParts;
};

my @Tests = (
    {
        Code   => '1,0,0,0,99',
        Result => '2,0,0,0,99',
        Text   => 'Day 2 - 1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2)',
    },
    {
        Code   => '2,3,0,3,99',
        Result => '2,3,0,6,99',
        Text   => 'Day 2 - 2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).',
    },
    {
        Code   => '2,4,4,5,99,0',
        Result => '2,4,4,5,99,9801',
        Text   => 'Day 2 - 2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).',
    },
    {
        Code   => '1,1,1,4,99,5,6,0,99',
        Result => '30,1,1,4,2,5,6,0,99',
        Text   => 'Day 2 - 1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.',
    },
    {
        Code   => '1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,1,5,19,23,2,6,23,27,1,27,5,31,2,9,31,35,1,5,35,39,2,6,39,43,2,6,43,47,1,5,47,51,2,9,51,55,1,5,55,59,1,10,59,63,1,63,6,67,1,9,67,71,1,71,6,75,1,75,13,79,2,79,13,83,2,9,83,87,1,87,5,91,1,9,91,95,2,10,95,99,1,5,99,103,1,103,9,107,1,13,107,111,2,111,10,115,1,115,5,119,2,13,119,123,1,9,123,127,1,5,127,131,2,131,6,135,1,135,5,139,1,139,6,143,1,143,6,147,1,2,147,151,1,151,5,0,99,2,14,0,0',
        Result => '4484226',
        Text   => 'Day 2 - puzzle',
    },
    {
        Code   => '1002,4,3,4,33',
        Result => '99',
        Text   => 'Day 5 - Test 1',
    },
    {
        Code   => '3,225,1,225,6,6,1100,1,238,225,104,0,1102,16,13,225,1001,88,68,224,101,-114,224,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,1101,8,76,224,101,-84,224,224,4,224,102,8,223,223,101,1,224,224,1,224,223,223,1101,63,58,225,1102,14,56,224,101,-784,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,29,46,225,102,60,187,224,101,-2340,224,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,1102,60,53,225,1101,50,52,225,2,14,218,224,101,-975,224,224,4,224,102,8,223,223,1001,224,3,224,1,223,224,223,1002,213,79,224,101,-2291,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1,114,117,224,101,-103,224,224,4,224,1002,223,8,223,101,4,224,224,1,224,223,223,1101,39,47,225,101,71,61,224,101,-134,224,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1102,29,13,225,1102,88,75,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1107,677,677,224,102,2,223,223,1006,224,329,1001,223,1,223,108,677,677,224,1002,223,2,223,1005,224,344,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,359,1001,223,1,223,1107,226,677,224,102,2,223,223,1006,224,374,1001,223,1,223,8,677,226,224,102,2,223,223,1006,224,389,101,1,223,223,8,226,226,224,102,2,223,223,1006,224,404,101,1,223,223,7,677,677,224,1002,223,2,223,1006,224,419,101,1,223,223,7,677,226,224,1002,223,2,223,1005,224,434,101,1,223,223,1108,677,226,224,1002,223,2,223,1006,224,449,1001,223,1,223,108,677,226,224,1002,223,2,223,1006,224,464,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,479,101,1,223,223,1007,677,677,224,1002,223,2,223,1006,224,494,1001,223,1,223,107,226,226,224,102,2,223,223,1005,224,509,1001,223,1,223,1008,677,226,224,102,2,223,223,1005,224,524,1001,223,1,223,1007,226,226,224,102,2,223,223,1006,224,539,101,1,223,223,1108,677,677,224,102,2,223,223,1005,224,554,1001,223,1,223,1008,677,677,224,1002,223,2,223,1006,224,569,101,1,223,223,1107,677,226,224,1002,223,2,223,1006,224,584,1001,223,1,223,7,226,677,224,102,2,223,223,1005,224,599,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,614,101,1,223,223,107,226,677,224,1002,223,2,223,1005,224,629,1001,223,1,223,107,677,677,224,1002,223,2,223,1006,224,644,101,1,223,223,1007,677,226,224,1002,223,2,223,1006,224,659,101,1,223,223,8,226,677,224,102,2,223,223,1005,224,674,1001,223,1,223,4,223,99,226',
        Result => '4601506',
        Text   => 'Day 5 - Test 2',
    },
    {
        Code   => '3,9,8,9,10,9,4,9,99,-1,8',
        Result => '1',
        Text   => 'Day 5 Part 2 - position mode - equal to - true',
        Input  => 8,
    },
    {
        Code   => '3,9,8,9,10,9,4,9,99,-1,8',
        Result => '0',
        Text   => 'Day 5 Part 2 - position mode - equal to - false',
        Input  => 7,
    },
    {
        Code   => '3,9,7,9,10,9,4,9,99,-1,8',
        Result => '1',
        Text   => 'Day 5 Part 2 - position mode - less than - true',
        Input  => 5,
    },
    {
        Code   => '3,9,7,9,10,9,4,9,99,-1,8',
        Result => '0',
        Text   => 'Day 5 Part 2 - position mode - less than - false',
        Input  => 9,
    },
    {
        Code   => '33,3,1108,-1,8,3,4,3,99',
        Result => '1',
        Text   => 'Day 5 Part 2 - immediate mode - equal to - true',
        Input  => 8,
    },
    {
        Code   => '33,3,1108,-1,8,3,4,3,99',
        Result => '1',
        Text   => 'Day 5 Part 2 - immediate mode - equal to - false',
        Input  => 7,
    },
    {
        Code   => '3,3,1107,-1,8,3,4,3,99',
        Result => '1',
        Text   => 'Day 5 Part 2 - immediate mode - less than - true',
        Input  => 5,
    },
    {
        Code   => '3,3,1107,-1,8,3,4,3,99',
        Result => '0',
        Text   => 'Day 5 Part 2 - immediate mode - less than - false',
        Input  => 9,
    },
    {
        Code   => '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9',
        Result => '0',
        Text   => 'Day 5 Part 2 - position mode - jump test - zero',
        Input  => 0,
    },
    {
        Code   => '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9',
        Result => '1',
        Text   => 'Day 5 Part 2 - position mode - jump test - nonzero',
        Input  => 1,
    },
    {
        Code   => '3,3,1105,-1,9,1101,0,0,12,4,12,99,1',
        Result => '0',
        Text   => 'Day 5 Part 2 - immediate mode - jump test 2 - zero',
        Input  => 0,
    },
    {
        Code   => '3,3,1105,-1,9,1101,0,0,12,4,12,99,1',
        Result => '1',
        Text   => 'Day 5 Part 2 - immediate mode - jump test 2 - nonzero',
        Input  => 1,
    },
    {
        Code   => '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99',
        Result => '999',
        Text   => 'Day 5 Part 2 - largest 999',
        Input  => 7,
    },
    {
        Code   => '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99',
        Result => '1000',
        Text   => 'Day 5 Part 2 - largest 1000',
        Input  => 8,
    },
    {
        Code   => '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99',
        Result => '1001',
        Text   => 'Day 5 Part 2 - largest 1001',
        Input  => 9,
    },
    {
        Code   => '3,225,1,225,6,6,1100,1,238,225,104,0,1102,16,13,225,1001,88,68,224,101,-114,224,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,1101,8,76,224,101,-84,224,224,4,224,102,8,223,223,101,1,224,224,1,224,223,223,1101,63,58,225,1102,14,56,224,101,-784,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,29,46,225,102,60,187,224,101,-2340,224,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,1102,60,53,225,1101,50,52,225,2,14,218,224,101,-975,224,224,4,224,102,8,223,223,1001,224,3,224,1,223,224,223,1002,213,79,224,101,-2291,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1,114,117,224,101,-103,224,224,4,224,1002,223,8,223,101,4,224,224,1,224,223,223,1101,39,47,225,101,71,61,224,101,-134,224,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1102,29,13,225,1102,88,75,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1107,677,677,224,102,2,223,223,1006,224,329,1001,223,1,223,108,677,677,224,1002,223,2,223,1005,224,344,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,359,1001,223,1,223,1107,226,677,224,102,2,223,223,1006,224,374,1001,223,1,223,8,677,226,224,102,2,223,223,1006,224,389,101,1,223,223,8,226,226,224,102,2,223,223,1006,224,404,101,1,223,223,7,677,677,224,1002,223,2,223,1006,224,419,101,1,223,223,7,677,226,224,1002,223,2,223,1005,224,434,101,1,223,223,1108,677,226,224,1002,223,2,223,1006,224,449,1001,223,1,223,108,677,226,224,1002,223,2,223,1006,224,464,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,479,101,1,223,223,1007,677,677,224,1002,223,2,223,1006,224,494,1001,223,1,223,107,226,226,224,102,2,223,223,1005,224,509,1001,223,1,223,1008,677,226,224,102,2,223,223,1005,224,524,1001,223,1,223,1007,226,226,224,102,2,223,223,1006,224,539,101,1,223,223,1108,677,677,224,102,2,223,223,1005,224,554,1001,223,1,223,1008,677,677,224,1002,223,2,223,1006,224,569,101,1,223,223,1107,677,226,224,1002,223,2,223,1006,224,584,1001,223,1,223,7,226,677,224,102,2,223,223,1005,224,599,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,614,101,1,223,223,107,226,677,224,1002,223,2,223,1005,224,629,1001,223,1,223,107,677,677,224,1002,223,2,223,1006,224,644,101,1,223,223,1007,677,226,224,1002,223,2,223,1006,224,659,101,1,223,223,8,226,677,224,102,2,223,223,1005,224,674,1001,223,1,223,4,223,99,226',
        Result => '5525561',
        Text   => 'Day 5 Part 2 - puzzle',
        Input  => 5,
    },

);

TEST:
for my $Test (@Tests) {

    my $Result = Compute($Test->{Code}, $Test->{Input});
    my $Check = $Result =~ $Test->{Result} ? 1 : 0;

    is(1, $Check, $Test->{Text} . "(Result: " . $Test->{Result} . ")");
}

sub AmpSequenceListGet {
    my ($From, $To) = @_;

    my @Result;
    for my $A ($From .. $To) {
        for my $B ($From .. $To) {
            for my $C ($From .. $To) {
                for my $D ($From .. $To) {
                    for my $E ($From .. $To) {
                        my @List = ($A, $B, $C, $D, $E);
                        my %Seen;
                        my $Skip;
                        for my $Value (@List) {
                            if ( $Seen{$Value} ) {
                                $Skip = 1;
                                last;
                            }

                            $Seen{$Value} = 1;
                        }

                        next if $Skip;

                        push @Result, \@List;
                    }
                }
            }
        }
    }

    return \@Result;
}

sub AmpRun { # 1342904 671452
    my ($Code, $Sequences, $Deep) = @_;

    my @Outputs;

    SEQ:
    for my $Sequence (@{ $Sequences }) {
        my $AmpOutputs   = 0;
        my $IndexMemory  = {};
        my $IndexCode    = {};
        my $IndexOutputs = {};

        # print "\n\nNew Sequence\n\n" if $Deep;

        my $AmpIndex = 0;
        my $Feedback = 0;
        AMP:
        while ( $AmpIndex < 5 ) {
            $IndexMemory->{$AmpIndex}    ||= 0;
            $IndexCode->{$AmpIndex}      ||= $Code;
            $IndexOutputs->{$AmpIndex}   ||= undef;

            my $SequenceValue = $Sequence->[$AmpIndex];
            # if ($Deep && $Feedback ) {
            #     $SequenceValue += 4;
            # }

            # print "SequenceValue $SequenceValue \n";

            my $RA = Compute($IndexCode->{$AmpIndex}, [ $SequenceValue, $AmpOutputs ], 1, $IndexMemory->{$AmpIndex});
            # print "Amp $AmpIndex computes ( $SequenceValue, $AmpOutputs ) with base index $IndexMemory->{$AmpIndex}\n" if $Deep;
            # print "Outputs: $RA->{Outputs}, Halted: $RA->{Halted}\n" if $Deep;
            # print "Parts $RA->{Index}\n" if $Deep;

            # next SEQ if $RA->{Halted} || $RA->{Outputs} eq '';

            $AmpOutputs = $RA->{Outputs} if $RA->{Outputs};
            $IndexOutputs->{$AmpIndex} = $RA->{Outputs};

            # push @Outputs, $AmpOutputs if $AmpIndex == 4;
            push @Outputs, $AmpOutputs if $RA->{Outputs} && $AmpIndex == 4;

            # print Dumper($RA);
            next SEQ if $RA->{Halted} && $Deep;

            if ($Deep) {
                $IndexMemory->{$AmpIndex} = $RA->{Index};
                $IndexCode->{$AmpIndex}   = $RA->{Parts};

                # if ($AmpIndex == 4 && $AmpOutputs eq '') {
                #     print Dumper($RA);
                #     print Dumper($AmpOutputs);
                #     # print Dumper(split /,/, $RA->{Parts});
                #     exit;
                # }

                if ($AmpIndex == 4) {
                    # print "---\n";
                    # print "AmpOutputs: $AmpOutputs\n";
                    # print Dumper($RA), "\n";
                    # print Dumper($IndexMemory), "\n";
                    # print Dumper($IndexCode), "\n";
                    # print Dumper($IndexOutputs), "\n";
                    $AmpIndex = 0;
                    # exit if $Feedback == 10;
                    # exit if $RA->{Halted};
                    # $Feedback += 1;

                    next AMP;
                }
            }

            $AmpIndex++;
        }

        last SEQ if $Deep;
    }


    return @Outputs
}

#
# Amplifier Controller Software
#

@Tests = (
    {
        Code      => $Data[0],
        Result    => '43210',
        Text      => 'Day 7 - Test 1',
        Sequences => [[4,3,2,1,0]],
    },
    {
        Code      => $Data[1],
        Result    => '54321',
        Text      => 'Day 7 - Test 2',
        Sequences => [[0,1,2,3,4]],
    },
    {
        Code      => $Data[2],
        Result    => '65210',
        Text      => 'Day 7 - Test 3',
        Sequences => [[1,0,4,3,2]],
    },
    {
        Code      => $Data[3],
        Result    => '262086',
        Text      => 'Day 7 - Puzzle',
        Sequences => AmpSequenceListGet(0, 4),
    },
    {
        Code      => $Data[4],
        Result    => '139629729',
        Text      => 'Day 7 Part 2 - Test 1',
        Sequences => AmpSequenceListGet(5, 9),
        Deep      => 1,
    },
    {
        Code      => $Data[5],
        Result    => '18216',
        Text      => 'Day 7 Part 2 - Test 2',
        Sequences => AmpSequenceListGet(5, 9),
        Deep      => 1,
    },
    {
        Code      => $Data[3],
        Result    => 'xxx',
        Text      => 'Day 7 Part 2 - Puzzle',
        Sequences => AmpSequenceListGet(5, 9),
        Deep      => 1,
    },

);

TEST:
for my $Test (@Tests) {
    my $Result = max( AmpRun($Test->{Code}, $Test->{Sequences}, $Test->{Deep}) );

    is($Result, $Test->{Result}, $Test->{Text} . "(Result: " . $Test->{Result} . ")");
}

done_testing();

1;

__DATA__
3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0

3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0

3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0

3,8,1001,8,10,8,105,1,0,0,21,42,67,84,109,122,203,284,365,446,99999,3,9,1002,9,3,9,1001,9,5,9,102,4,9,9,1001,9,3,9,4,9,99,3,9,1001,9,5,9,1002,9,3,9,1001,9,4,9,102,3,9,9,101,3,9,9,4,9,99,3,9,101,5,9,9,1002,9,3,9,101,5,9,9,4,9,99,3,9,102,5,9,9,101,5,9,9,102,3,9,9,101,3,9,9,102,2,9,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99

3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5

3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10