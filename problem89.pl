#!/usr/bin/perl

use strict;

my %values = (
	I => 1,
	V => 5,
	X => 10,
	L => 50,
	C => 100,
	D => 500,
	M => 1000,
);

sub roman_to_integer {
	my ($roman_string) = shift;
	my @roman = split //, uc $roman_string;
	
	my $value = 0;

	while (@roman) {
		my $current_digit = shift @roman;
		my $next_digit = shift @roman;

		if (defined($next_digit) && 
				$values{$current_digit} < $values{$next_digit}) {
			$value += $values{$next_digit} - $values{$current_digit};
		} else {
			if (defined($next_digit)) {
				unshift @roman, $next_digit;
			}
			$value += $values{$current_digit};
		}
	}
	return $value;
}

my %roman_to_integer_tests = qw/
	xvi 16
	xiiiiii 16
	vvvi 16
	iv 4
	xix 19
	x 10
	ix 9
	xviiii 19
	xviv 19
	xxxxviiii 49
	il 49
	xlix 49
	iiii 4
	ix 9
	viiii 9
	xxxxviiii 49
	xxxxix 49
	xlviiii 49
	xlix 49
	mccccccvi 1606
	mdcvi 1606/;

for my $r (keys %roman_to_integer_tests) {
	my $v = roman_to_integer($r);
	if ($v != $roman_to_integer_tests{$r}) {
		printf "FAIL: %s: expected %d != actual %d\n", $r,
			$roman_to_integer_tests{$r}, $v;
	}
}

sub integer_to_roman_minimal {
	my $n = shift;
	my $roman = '';

	while ($n >= 1000) {
		$roman .= 'M';
		$n -= 1000;
	}
	if ($n >= 900) {
		$roman .= 'CM';
		$n -= 900;
	} elsif ($n >= 500) {
		$roman .= 'D';
		$n -= 500;
	} elsif ($n >= 400) {
		$roman .= 'CD';
		$n -= 400;
	}

	while ($n >= 100) {
		$roman .= 'C';
		$n -= 100;
	}
	if ($n >= 90) {
		$roman .= 'XC';
		$n -= 90;
	} elsif ($n >= 50) {
		$roman .= 'L';
		$n -= 50;
	} elsif ($n >= 40) {
		$roman .= 'XL';
		$n -= 40;
	}

	while ($n >= 10) {
		$roman .= 'X';
		$n -= 10;
	}
	if ($n >= 9) {
		$roman .= 'IX';
		$n -= 9;
	} elsif ($n >= 5) {
		$roman .= 'V';
		$n -= 5;
	} elsif ($n >= 4) {
		$roman .= 'IV';
		$n -= 4;
	}

	while ($n >= 1) {
		$roman .= 'I';
		$n -= 1;
	}
	
	return $roman;
}

for (my $i = 1; $i < 5000; $i++) {
	my $r = integer_to_roman_minimal($i);
	my $i2 = roman_to_integer($r);

	if ($i != $i2) {
		printf "FAIL round-trip: %d -> %s -> %d\n", $i, $r, $i2;
	} else {
#		printf "%5d = %s\n", $i, $r;
	}
}

#exit 0;

my $total_saved = 0;

while (<>) {
	chomp;
	my $orig = $_;
	my $n = roman_to_integer($orig);
	my $r = integer_to_roman_minimal($n);

	my $saved = (length $orig) - (length $r);
	$total_saved += $saved;

	printf "%20s -> %5d -> %20s (%d shorter)\n", $_, $n, $r, $saved;
}

printf "%d\n", $total_saved;

