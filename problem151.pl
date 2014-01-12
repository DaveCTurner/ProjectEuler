#!/usr/bin/perl

use Math::BigRat;

sub f {
	my ($envelope, $total, $singletonCount) = @_;

	return Math::BigRat->new(0,1) unless $total;

	if (1 == $total) {
		$singletonCount += 1;
	}
	printf("Envelope = [%s], singletons = %d\n", 
		(join ' ', @$envelope), $singletonCount);

	my $expected = Math::BigRat->new(0,1);

	for (my $i = 1; $i <= 5; $i++) {
		if ($envelope->[$i]) {
			$envelope->[$i] -= 1;
			for (my $j = $i+1; $j <= 5; $j++) {
				$envelope->[$j] += 1;
			}
			$expected->badd(
				f($envelope, $singletonCount)->bmul($envelope->[$i]+1));
			$envelope->[$i] += 1;
			for (my $j = $i+1; $j <= 5; $j++) {
				$envelope->[$j] -= 1;
			}
		}
	}

	return $expected->bdiv($total);
}

printf("%s\n", f([0,0,0,1,0,0], 0)->bsub(2)->bstr());
