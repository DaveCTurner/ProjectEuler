#!/usr/bin/perl

use Math::BigInt;
use strict;

my @factorials = (Math::BigInt->new(1));

for (my $n = 1; $n <= 50; $n++) {
	$factorials[$n] = $factorials[$n-1]->copy()->bmul($n);
}

sub comb {
	my ($n, @rs) = @_;
	my $c = $factorials[$n]->copy();
	for my $r (@rs) {
		$c->bdiv($factorials[$r]);
		$n -= $r;
	}
	return $c->bdiv($factorials[$n]);
}

my $n = 50;

my $acc = Math::BigInt->new(0);
for (my $reds = 0; $reds * 2 <= $n; $reds++) {
	for (my $greens = 0; $greens * 3 + $reds * 2 <= $n; $greens++) {
		for (my $blues = 0; $blues * 4 + $greens * 3 + $reds * 2 <= $n;
				$blues++) {
			$acc->badd(comb($n - 2*$reds - 3*$greens - 4*$blues
				+ $reds + $greens + $blues, $reds, $greens, $blues));
		}
	}
}

printf ("%s\n", $acc->badd());

