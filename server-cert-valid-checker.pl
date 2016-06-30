#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use feature 'say';
binmode(STDOUT,'utf8:');

use DateTime;

my $domain=$ARGV[0] || '';

if($domain eq '') {
	say "USAGE: $0 [domain]";
	exit 255;
}

my $dates=`echo -n | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | openssl x509 -noout -dates`;

{
	if($dates=~/^notBefore=(.+)$/m) {
		my $dt=datetime_parse($1);
		say "notBefore\t".$dt->ymd.' '.$dt->hms." JST";
	}
	if($dates=~/^notAfter=(.+)$/m) {
		my $dt=datetime_parse($1);
		say "notAfter\t".$dt->ymd.' '.$dt->hms." JST";
	}
}

sub datetime_parse {
	my $datetime=shift;
	my @dt=();
	if($datetime=~/^(\w+)\s{1,2}(\d+)\s(\d{1,2}):(\d{1,2}):(\d{1,2}) (\d{4}) (\w+)$/) {
		@dt=(
			{ 
				'Jan' => 1, 'Feb' => 2,  'Mar' => 3,  'Apr' => 4,
				'May' => 5, 'Jun' => 6,  'Jul' => 7,  'Aug' => 8,
				'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12,	
			}->{$1},
			$2,$3,$4,$5,$6,$7);
		my $dt=DateTime->new(
			year      => $dt[5],
			month     => $dt[0],
			day       => $dt[1],
			hour      => $dt[2],
			minute    => $dt[3],
			second    => $dt[4],
			time_zone => 'UTC'
		);

		$dt->set_time_zone('Asia/Tokyo');
		return $dt;
	}
}

