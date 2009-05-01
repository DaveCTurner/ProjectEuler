#!/usr/bin/perl

use strict;
use Math::BigInt;

# Need to find square of the form n^2 ~= /1.2.3.4.5.6.7.8.9.0/
# which is 19 digits so 10^18 <= n^2 < 2 * 10^18
# so 10^9 <= n <= 1.4 * 10^9

# Must be a multiple of 10, therefore a multiple of 100,
# so simpler to seek 10^8 <= n <= 1.4 * 10^8
# such that n^2 ~= /1.2.3.4.5.6.7.8.9/

# Idea is to build up possible values for n from the right.

my @suffices = (Math::BigInt->new());

my $power_of_ten = Math::BigInt->new(1);
my $last_power_of_ten = Math::BigInt->new(1);

my $max_digit = 9;
my $max_length = 8;

for (my $length = 1; $length <= $max_length; $length += 1) {
#	printf STDERR "%d\n", $length;

	# $length = the length of the suffix we're currently looking for.
	# @suffices contains all the suffices of length $length-1 that were
	# found last time round.

	my $required_head = sprintf("%d", 10 - ($length + 1)/2);
	
	# $power_of_ten contains the modulus to cut everything down
	# to $length digits.
	$power_of_ten->bmul(10);

	# Know that the number is <= 1.4 * 10^$max_length
	if ($length == $max_length) {
		$max_digit = 4;
	}

	my @new_suffices = ();
	# Try every possible digit/suffix pair.
	for (my $new_digit = 0; $new_digit <= $max_digit; $new_digit += 1) {
		my $new_digit_int 
			= Math::BigInt->new($new_digit)->bmul($last_power_of_ten);
		foreach my $suffix (@suffices) {
			my $new_suffix = $suffix->copy()->badd($new_digit_int);
			if ($length % 2 == 0) {
				# No constraints on the even-numbered positions
				push @new_suffices, $new_suffix;
			} else {
				my $nhead = $new_suffix->copy()->bmodpow(2, $power_of_ten)
					->bdiv($last_power_of_ten)->bstr();
				if ($nhead eq $required_head) {
#					printf "%s squares to %s\n", $new_suffix->bstr(), 
#						$new_suffix->copy()->bpow(2)->bstr();
					push @new_suffices, $new_suffix;
#				} else {
#					printf "%s squares to %s not %s\n", $new_suffix, $n,
#						$required_head;
				}
			}
		}
	}

	$last_power_of_ten->bmul(10);

	@suffices = @new_suffices;
	@new_suffices = undef;

	printf STDERR "%d: %d\n", $length, (scalar @suffices);
}

#my $found_suffix = undef;

for my $suffix (@suffices) {
	$suffix->badd($last_power_of_ten)->bmul(10);
	my $nsq = $suffix->copy()->bpow(2)->bstr();
	if ($nsq =~ /1.2.3.4.5.6.7.8.9.0/) {
#		$found_suffix = $suffix->copy();
		printf "%s^2 = %s\n", $suffix->bstr(), $nsq;
	}
#	printf "%s^2 = %s\n", $suffix->bstr(), $nsq;
}

#if (defined($found_suffix)) {
#	printf "%s\n", $found_suffix->bstr();
#}
