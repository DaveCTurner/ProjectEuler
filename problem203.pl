#!/usr/bin/perl

use Math::BigInt only => 'GMP';
use strict;

printf("%s\n", Math::BigInt->new(50)->bnok(26)->bstr());
