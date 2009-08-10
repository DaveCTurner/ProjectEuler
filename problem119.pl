#!/usr/bin/perl

use strict;
use Math::BigInt only => 'GMP';

$| = 1;

sub digit_sum {
	my ($n) = @_;
	my @n_digits = split //, $n->bstr();
	my $sum = 0;
	map { $sum += $_; } @n_digits;
	return $sum;
}

my $queue = [ 2, 2, Math::BigInt->new(4), [ 3, 2, Math::BigInt->new(9) ] ];
my $max_radix = 3;

my $found_count = 0;

my $current;
while(1) {

#	$current = $queue;
#	while (defined($current)) {
#		printf("%d^%d=%s\n", @$current);
#		$current = $current->[3];
#	}
#	printf("\n");
#
	# Pop head off queue
	$current = $queue;
	$queue = $current->[3];
	$current->[3] = undef;

	# Check digit sum property
	if (digit_sum($current->[2]) == $current->[0]) {
		printf("%d: %d^%d=%s FOUND\n", ++$found_count, @$current);
		last if 30 <= $found_count;
	}

	# Move current to next pos.
	$current->[1] += 1;
	$current->[2]->bmul($current->[0]);
	
	# Seek greatest lower bound
	my $predecessor = $queue;
	my $prepredecessor = undef;
	while ($current->[2]->bcmp($predecessor->[2]) > 0) {
		unless (defined($predecessor->[3])) {
			# Have run out of items without finding a better one.
			# Therefore, add more items.
			if ($max_radix >= 100) { last; }
			$max_radix++;
			my $new_power = $predecessor->[2]->copy()
				->blog($max_radix, 100)->bfloor()->numify();
			my $new_item = [ $max_radix, $new_power,
				Math::BigInt->new($max_radix)->bpow($new_power), undef ];
			while ($predecessor->[2]->bcmp($new_item->[2]) > 0) {
				$new_item->[1] += 1;
				$new_item->[2]->bmul($new_item->[0]);
			}
#			printf("Adding %d^%d=%s\n", @$new_item);
			$predecessor->[3] = $new_item;
		}

		$prepredecessor = $predecessor;
		$predecessor = $predecessor->[3];
	}

	if (defined($prepredecessor)) {
		$current->[3] = $prepredecessor->[3];
		$prepredecessor->[3] = $current;
	} else {
		$current->[3] = $queue;
		$queue = $current;
	}
}

printf("%s\n", $current->[2]->bstr());
