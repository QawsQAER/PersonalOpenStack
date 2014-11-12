use strict;
use warnings;

open(FILE1,$ARGV[0]) || die "Error: $!\n";
my @lines = <FILE1>;

foreach (@lines)
{
	my $result = $_;
	if(/^uuid.*[(].*RO.*[)]\s*:\s+(.*)/)
	{
		print $1;
	}
}


