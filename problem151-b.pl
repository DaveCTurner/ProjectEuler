#!/usr/bin/perl

use Math::BigRat;

sub f {
	my ($envelope, $singletonCount) = @_;

	unless (@$envelope) {
		return $singletonCount;
	}

	if (1 == @$envelope) {
		$singletonCount += 1;
	}
	#printf("Envelope = [%s], singletons = %d\n",
	#	(join ' ', @$envelope), $singletonCount);

	my $expected = Math::BigRat->new(0,1);
	my @envelopeUnused = @$envelope;
	my @envelopeUsed = ();

	while (@envelopeUnused) {
		my $paper = shift @envelopeUnused;

		if (5 == $paper) {
			$expected->badd(f([@envelopeUnused, @envelopeUsed], 
				$singletonCount));
		} else {
			$expected->badd(f([@envelopeUnused, @envelopeUsed,
				(($paper+1)..5)], $singletonCount));
		}

		push @envelopeUsed, $paper;
	}

	return $expected->bdiv(scalar @$envelope);
}

printf("%s\n", f([2], 0)->bsub(2)->bstr());
