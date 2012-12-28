use strict;
use warnings;
use Test::More tests => 4;

BEGIN { use_ok 'Catalyst::Test', 'MoneyTraq' }
BEGIN { use_ok 'MoneyTraq::Controller::Auth' }

ok( request('/auth')->is_redirect, 'Request should redirect to logon' );
ok( request('/auth/login')->is_success, 'Request should redirect to logon' );


