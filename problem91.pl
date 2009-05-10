#!/usr/bin/perl

sub hcf {
	my ($a, $b) = @_;
	while ($a) {
		while ($a <= $b) {
			$b -= $a;
		}
		($a, $b) = ($b, $a);
	}
	return $b;
}

my $size = 50;

my $count = 0;

# There are $size*$size right triangles with the right angle at the origin:
# pick a point on the +ve x axis and a point on the +ve y axis.
$count += $size*$size;

# There are $size*$size right triangles with the right angle on the x axis:
# pick a point on the +ve x axis and a point on the +ve y axis.
$count += $size*$size;

# There are $size*$size right triangles with the right angle on the y axis:
# pick a point on the +ve x axis and a point on the +ve y axis.
$count += $size*$size;

# Otherwise the right angle is at ($qx,$qy) where both are positive.
for (my $qx = 1; $qx <= $size; $qx += 1) {
	for (my $qy = 1; $qy <= $size; $qy += 1) {
		my $hcf = hcf($qx,$qy);
		my ($dpx, $dpy) = ($qy/$hcf, -$qx/$hcf);
		
		my ($px, $py) = ($qx+$dpx, $qy+$dpy);
		while ($py >= 0 && $px <= $size) {
			$count += 1;
			$px += $dpx;
			$py += $dpy;
		}
		
		my ($px, $py) = ($qx-$dpx, $qy-$dpy);
		while ($px >= 0 && $py <= $size) {
			$count += 1;
			$px -= $dpx;
			$py -= $dpy;
		}
	}
}

printf("%d\n", $count);
