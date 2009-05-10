#!/usr/bin/perl

use Math::BigInt;
use strict;

my @primes = qw/2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59/;

my $target = 4000000;
my $bestSoFar = undef;

sub enumerate {
	my ($powers, $depth, $countAcc, $primeAcc) = @_;

#	printf("%s %s\n", (join ' ', @$powers), $primeAcc->bstr());

	if (defined($bestSoFar) && $bestSoFar->bcmp($primeAcc) < 0) {
		# Have already done this well, so give up.
		return;
	}

	if ($countAcc > 2 * $target - 1) {
		# Have exceeded the target with a smaller primeAcc than ever before.
		$bestSoFar = $primeAcc->copy();
		printf("%s\n", $bestSoFar->bstr());
		return;
	}

	if ($depth && 0 == $powers->[$depth-1]) {
		# Max power is now 0 - cannot change.
		return;
	}


	if ($depth >= $#primes) {
		die "Run out of primes";
		return;
	}

	my $maxPower = $target + 2;
	if ($depth) {
		$maxPower = $powers->[$depth-1];
	}

	my $newPrimeAcc = $primeAcc->copy();
	for (my $newPower = 0; $newPower <= $maxPower; $newPower += 1) {
		enumerate([@$powers, $newPower], $depth+1, 
			$countAcc * (2 * $newPower + 1), $newPrimeAcc);
		$newPrimeAcc->bmul($primes[$depth]);
		last if (defined($bestSoFar) && $bestSoFar->bcmp($newPrimeAcc) < 0);
	}
}

enumerate([], 0, 1, Math::BigInt->new(1));
