#!/usr/bin/perl

use Math::BigInt;

use strict;

sub isLychrel {
	my ($n) = @_;
	my $nfwd = Math::BigInt->new($n);
	my $nrev = Math::BigInt->new(scalar reverse $nfwd->bstr());
	
	my $iter = 0;
	do {
		#printf("%s + %s = ", $nfwd, $nrev);
		$nfwd->badd($nrev);
		#printf("%s\n", $nfwd);
		$nrev = Math::BigInt->new(scalar reverse ($nfwd->bstr()));
		$iter += 1;
	} while ((0 != $nfwd->bcmp($nrev)) && $iter < 50);
	
	return (50 == $iter) ? 1 : 0;
}

my $count = 0;
for (my $i = 1; $i < 10000; $i++) {
	if (isLychrel($i)) {
		$count += 1;
	}
}
printf("%d\n", $count);
