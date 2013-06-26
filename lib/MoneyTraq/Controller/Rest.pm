package MoneyTraq::Controller::Rest;

use strict;
use warnings;
use base qw/Catalyst::Controller::REST/;
use DateTime;

sub notsetup :Local {
	my ($self, $c) = @_;

	$self->status_ok($c,
					 $self->render_error(message => "System not set up yet. Please set up the system via your browser."));
}

sub render_error :Private {
	my ($self, %data);

	$data{success} = 0;
	return %data;
}

sub render_success :Private {
	my ($self, %data);

	$data{success} = 1;
	return %data;
}