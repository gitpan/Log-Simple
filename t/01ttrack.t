#########################

use Test::More tests => 2;
BEGIN { use_ok('Log::Simple' => 2 ) };

ok( time_track(), "time_track" );
