use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MoneyTraq';
use MoneyTraq::Controller::Setup;

ok( request('/setup')->is_success, 'Request should succeed' );
done_testing();
