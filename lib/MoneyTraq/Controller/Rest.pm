package MoneyTraq::Controller::Rest;

use strict;
use warnings;
use base qw/Catalyst::Controller::REST/;
use DateTime;

# transaction object
sub transaction : Local : ActionClass('REST') {}

sub transaction_PUT {
	my ($self, $c) = @_;

	$c->authenticate({}, 'http');

	$self->status_created($c, {
		location => 'not provided',
		entity => {
			success => 1,
			message => "you did it!"
			}
		}
	);
}

sub notsetup :Local {
	my ($self, $c) = @_;

	$self->status_ok($c, {
					entity => {
						success => 1,
					 	message => "System not set up yet. Please set up the system via your browser."
					 }
				}
			);
}


return 1;