#!/usr/bin/perl

use Math::BigInt;
use strict;

my @factorials = (Math::BigInt->new(1));

for (my $n = 1; $n <= 120; $n++) {
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

# Rationale here is to count the non-bouncy numbers.
#
# There are (n+9 choose 9) increasing numbers with at most n digits: arrange n
# dots and 9 bars (e.g. |||..|.||..|.|| -> 334667)
#
# There are also (n+9 choose 9) n-digit decreasing numbers by the same
# argument (although ten of them are constant).
# Therefore there are (\sum(k=1 to n) (k+1 choose 9)) - 10n strictly
# decreasing numbers.
#

# Of these, some are constant and hence both increasing and
# decreasing, so counted twice - there are ten of them.

my $n = 100;

my $count = comb($n + 9, 9)->bsub(1); # Increasing numbers, except 0
for (my $k = 1; $k <= $n; $k++) {
	# k-digit strictly decreasing numbers.
	$count->badd(comb($k + 9, 9))->bsub(10);
}
printf("%s\n", $count->bstr());
