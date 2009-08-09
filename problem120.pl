#!/usr/bin/perl

# (a+1)^n == 1+an mod a^2    and    (a-1)^n == (-1)^n (1-an) mod a^2
# so (a-1)^n + (a+1)^n == 2an mod a^2 if n odd (and == 2 if n even)
# so look for the maximum value of 2an mod a^2 where n is odd
# which is achieved when 2n < a

use strict;
use POSIX qw/floor/;
use Math::BigInt;


sub rmax {
	my $a = shift;

	if ($a & 0x01) { 
		return $a * ($a - 1);
	} else {
		return $a * ($a - 2);
	}
}

sub rmax_brute_force {
	my $a = shift;

	my $rmax = -1;

	printf("Calculating rmax for a = %d\n", $a);
	for (my $n = 0; $n < 1000; $n++) {
		my $p1 = Math::BigInt->new($a)->bsub(1)->bpow($n);
		my $p2 = Math::BigInt->new($a)->badd(1)->bpow($n);
		my $r = $p1->badd($p2)->bmod($a*$a)->numify();
		if ($r > $rmax) {
			printf("(%d-1)^%d + (%d+1)^%d == %d mod %d\n",
				$a, $n, $a, $n, $r, $a*$a);
			$rmax = $r;
		}

		if ($rmax + 2 * $a >= $a * $a) { last; }
	}

	return $rmax;
}

my $check_against_brute_force = 1;
for (my $i = 3; $i <= 100 && $check_against_brute_force; $i++) {
	my $q = rmax($i);
	my $q2 = rmax_brute_force($i);
	if ($q != $q2) {
		printf("FAIL: Expected %d != actual %d\n", $q2, $q);
	} else {
		printf("OK  : %d\n", $q);
	}
}

my $total = 0;
for (my $i = 3; $i <= 1000; $i++) {
	$total += rmax($i);
}
printf("%d\n", $total);
