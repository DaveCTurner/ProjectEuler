#!/usr/bin/perl

use Math::BigInt;

%cubeCount = ();

for (my $n = 1; $n < 10000; $n++) {
	my $nCubed = Math::BigInt->new($n)->bpow(3);
	my $nDigits = join '', sort split //, $nCubed->bstr();
	if (!defined($cubeCount{$nDigits})) {
		$cubeCount{$nDigits} = [];
	}
	push @{$cubeCount{$nDigits}}, $n;
}

my $bestN = 10000;
for my $digits (keys %cubeCount) {
	if (@{$cubeCount{$digits}} >= 5) {
		my $n = (sort @{$cubeCount{$digits}})[0];
		if ($n < $bestN) {
			$bestN = $n;
		}
	}
}
my $nCubed = Math::BigInt->new($bestN)->bpow(3);
printf "%s\n", $nCubed->bstr();
