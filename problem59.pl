#!/usr/bin/perl

use strict;

chomp $ARGV[0];
my @encoded = split /,/, $ARGV[0];

sub decode {
	my ($passcode) = @_;
	my @passcode = unpack 'C3', $passcode;
	
	my @decoded = ();

	for (my $i = 0; $i <= $#encoded; $i++) {
		my $passcodePosition = $i % 3;
		push @decoded, $encoded[$i] ^ $passcode[$passcodePosition];
	}

	return pack 'C*', @decoded;
}

my @passcodeTry = (0, 0, 0);

for ($passcodeTry[0] = 1; $passcodeTry[0] <= 26; $passcodeTry[0] += 1) {
	for ($passcodeTry[1] = 1; $passcodeTry[1] <= 26; $passcodeTry[1] += 1) {
		for ($passcodeTry[2] = 1; $passcodeTry[2] <= 26; $passcodeTry[2] += 1) {

			my $password = pack 'C3', (map { $_ + 96 } @passcodeTry);

			my $decoded = decode($password);

			my $decoded_UC = uc $decoded;

			if ($decoded_UC =~ / THE/ &&
				$decoded_UC =~ / AND /) {

				print "$password\n";
				my $total = 0;
				map { $total += $_ } unpack 'C*', $decoded;
				print "$total\n";
				print "$decoded\n\n";
			}

		}
	}
}
