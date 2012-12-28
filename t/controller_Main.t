use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'MoneyTraq' }
BEGIN { use_ok 'MoneyTraq::Controller::Main' }

ok( request('/main')->is_redirect, 'Request should redirect to /auth/login' );


