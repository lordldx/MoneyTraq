use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'MoneyTraq' }
BEGIN { use_ok 'MoneyTraq::Controller::Main' }

ok( request('/main')->is_success, 'Request should succeed' );


