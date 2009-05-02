#!/usr/bin/perl

use Math::BigInt;
use strict;

sub sqrt2_cf {
	my ($i) = @_;
	# sqrt 2
	return (0 == $i ? 1 : 2);
}

sub e_cf {
	my ($i) = @_;
	# e
	if (0 == $i) { return 2; }
	if (2 != ($i % 3)) { return 1; }
	return (($i + 1) / 3) * 2;
}

sub continuedFractionConvergent {
	my ($i, $cf) = @_;
	my $n = Math::BigInt->new($cf->($i-1));
	my $d = Math::BigInt->new()->bone();
	for (my $j = $i-2; $j >= 0; $j--) {
		($n, $d) = ($d, $n);
		$n->badd($d->copy()->bmul($cf->($j)));
	}
	return ($n, $d);
}

sub digitSum {
	my ($n) = @_;
	my $total = 0;
	map { $total += $_ } split //, $n->bstr();
	return $total;
}

print "Convergents of sqrt(2)\n";
for (my $i = 1; $i <= 10; $i++) {
	my ($n, $d) = continuedFractionConvergent($i, \&sqrt2_cf);
	printf "%d %s/%s\n", $i, $n->bstr(), $d->bstr();
}
print "\n";

print "Convergents of e, with numerator digit sums\n";
for (my $i = 1; $i <= 10; $i++) {
	my ($n, $d) = continuedFractionConvergent($i, \&e_cf);
	printf "%d %s/%s %d\n", $i, $n->bstr(), $d->bstr(), digitSum($n);
}
print "\n";

my ($n, $d) = continuedFractionConvergent(100, \&e_cf);
printf "%s/%s\n%d\n", $n->bstr(), $d->bstr(), digitSum($n);

