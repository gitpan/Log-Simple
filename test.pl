#########################

use Test;
BEGIN { plan tests => 6 };

use Log::Simple( 2 );
ok(1);

#########################

ok( 0, logger( 0, "test" ) );
ok( 1, logger( 1, "test" ) );
ok( 2, logger( 2, "test" ) );
ok( -1, logger( 3, "test" ) );
ok( "time_track", time_track() );
