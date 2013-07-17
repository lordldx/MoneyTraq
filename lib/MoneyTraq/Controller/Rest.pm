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

  if (ValidateTransactionData($c->req->data)) {
    my $transaction = $c->model('MoneyTraqDB::Transactions')->create({
                                                                      transaction_type_id => $c->req->data->{transaction_type_id},
                                                                      account_id => $c->req->data->{account_id},
                                                                      description => $c->req->data->{description},
                                                                      dat_entry => $c->datetime(),
                                                                      dat_valid => $c->req->data->{dat_valid},
                                                                      cancelled => 0,
                                                                      user_id => $c->user()->id,
                                                                     });

    $self->status_created($c, {
                               location => "not provided",
                               entity => {
                                          transaction_id => $transaction->id,
                                          success => 1,
                                          message => "Transaction created."
                                         }
                              }
                         );
  } else {
    $self->status_bad_request($c, message => "Missing arguments");
  }
}

sub ValidateTransactionData {
  my $data = shift;

  return exists $data->{transaction_type_id} &&
    exists $data->{account_id} &&
      exists $data->{description} &&
        exists $data->{dat_valid};
}

sub notsetup :Local {
	my ($self, $c) = @_;

	$self->status_ok($c, {
                        entity => {
                                   success => 0,
                                   message => "System not set up yet. Please set up the system via your browser."
                                  }
                       }
                  );
}


return 1;
