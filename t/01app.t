use strict;
use warnings;
use Test::More tests => 2;

BEGIN { use_ok 'Catalyst::Test', 'MoneyTraq' }

ok( request('/')->is_redirect, 'Request should redirect' );
