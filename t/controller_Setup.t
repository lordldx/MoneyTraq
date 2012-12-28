use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MoneyTraq';
use MoneyTraq::Controller::Setup;

ok( request('/setup')->is_redirect, 'Request should redirect to /auth/login' );
done_testing();
