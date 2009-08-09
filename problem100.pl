#!/usr/bin/perl

use strict;
use Math::BigInt;

my $n = Math::BigInt->new(0);
my $n_acc = Math::BigInt->new(1); # = 2n(n-1)+1

my $m = Math::BigInt->new(0); # Square this
my $m_acc = Math::BigInt->new(0); # = m^2

my $threshold = Math::BigInt->new('1000000000000');
$n = $threshold->copy();
$n_acc = $n->copy()->bsub(1)->bmul(2)->bmul($n)->badd(1);

$m = $threshold->copy()->bmul(70)->bdiv(100);
$m_acc = $m->copy()->bpow(2);

while(1) {
	my $cmp = $n_acc->bcmp($m_acc);

	if (0 == $cmp) {
		my $p = $m->badd(1)->bdiv(2)->bstr();
		printf("n = %s, m = %s, 2n(n-1)+1 = m^2 = %s, p = %s\n", $n->bstr(),
			$m->bstr(), $n_acc->bstr(), $p);
		if ($threshold->bcmp($n) < 0) {
			printf("%s\n", $p);
			last;
		}
	}

	if (0 <= $cmp) {
		$m_acc->badd($m->copy()->bmul(2)->badd(1));
		$m->binc();
	} else {
		$n_acc->badd($n->copy()->bmul(4));
		$n->binc();
	}
}
