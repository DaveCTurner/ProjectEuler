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
for (my $k = 2; $k <= 4; $k++) {
	for (my $x = 1; $x * $k <= $n; $x++) {
		$acc->badd(comb($n - $k * $x + $x, $x));
	}
}

printf ("%s\n", $acc->badd());

