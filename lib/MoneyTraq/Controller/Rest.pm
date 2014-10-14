package MoneyTraq::Controller::Rest;

use strict;
use warnings;
use base qw/Catalyst::Controller::REST/;
use DateTime;

# REST objects
sub transaction : Local : ActionClass('REST') {}
sub transactionDetail : Local : ActionClass('REST') {}
sub currentIncome : Local : ActionClass('REST') {}
sub currentExpense : Local : ActionClass('REST') {}
sub transactionTypeList : Local : ActionClass('REST') {}
sub accountList : Local : ActionClass('REST') {}
sub transactionAttributeList : Local : ActionClass('REST') {}
sub version : Local : ActionClass('REST') {}

sub transaction_POST {
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
    #  - transaction_attributes
    foreach ($c->req->data->{attributes}) {
      $c->log->debug("Value of transaction_attribute_id is" . $_);
      $c->model('MoneyTraqDB::TransactionsTransactionAttributes')->create({
                                                                           transaction_id => $transaction->id,
                                                                           transaction_attribute_id => $_
                                                                          });
    }

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

sub transactionDetail_POST {
  my ($self, $c) = @_;

  $c->authenticate({}, 'http');

  if (ValidateTransactionDetailData($c->req->data)) {
    if (TransactionExists($c, $c->req->data->{transaction_id})) {
      my $detail = $c->model('MoneyTraqDB::TransactionDetails')->create({
                                                                         transaction_id => $c->req->data->{transaction_id},
                                                                         account_id => $c->req->data->{account_id},
                                                                         amount => $c->req->data->{amount}
                                                                        });
      $self->status_created($c, {
                                 location => "not provided",
                                 entity => {
                                            success => 1,
                                            message => "TransactionDetail created."
                                           }
                                }
                           );
    } else {
      $self->status_bad_request($c, message => "Transaction does not exist.");
    }
  } else {
    $self->status_bad_request($c, message => "Missing arguments");
  }
}

sub currentIncome_GET {
  my ($self, $c) =  @_;

  $c->authenticate({}, 'http');

  my $transactions = $self->GetThisMonthsIncomeTransactions($c);
  if (defined $transactions) {
    my $currentIncome = 0;
    $currentIncome += $_->getTotal() foreach (@$transactions);
    $self->status_ok($c, entity => {
                                    success => 1,
                                    currentIncome => $currentIncome
                                   })
  } else {
    $self->status_bad_request($c, message => "Failed to retrieve transactions.");
  }
}

sub currentExpense_GET {
  my ($self, $c) =  @_;

  $c->authenticate({}, 'http');

  my $transactions = $self->GetThisMonthsExpenseTransactions($c);
  if (defined $transactions) {
    my $currentExpense = 0;
    $currentExpense += $_->getTotal() foreach (@$transactions);
    $self->status_ok($c, entity => {
                                    success => 1,
                                    currentExpense => $currentExpense
                                   })
  } else {
    $self->status_bad_request($c, message => "Failed to retrieve transactions.");
  }
}

sub transactionTypeList_GET {
  my ($self, $c) =  @_;

  $c->authenticate({}, 'http');

  return $self->status_ok($c, entity => {
                                         success => 1,
                                         transactionTypeList => [$c->model('MoneyTraqDB::TransactionTypes')->all]
                                        });
}

sub accountList_GET {
  my ($self, $c) =  @_;

  $c->authenticate({}, 'http');

  return $self->status_ok($c, entity => {
                                         success => 1,
                                         accountList => [$c->model('MoneyTraqDB::Accounts')->all]
                                        });
}

sub transactionAttributeList_GET {
  my ($self, $c) =  @_;

  $c->authenticate({}, 'http');

  return $self->status_ok($c, entity => {
                                         success => 1,
                                         transactionAttributeList => [$c->model('MoneyTraqDB::TransactionAttributes')->all]
                                        });
}

sub version_GET {
  my ($self, $c) = @_;

  # no authentication!

  return $self->status_ok($c, entity => {
                                         success => 1,
                                         version => $c->config->{version}
                                        });
}

sub GetThisMonthsIncomeTransactions {
  my ($self, $c) = @_;
  return $self->GetThisMonthsTransactions(1);
}

sub GetThisMonthsExpenseTransactions {
  my ($self, $c) = @_;
  return $self->GetThisMonthsTransactions(2);
}

sub GetThisMonthsTransactions {
  my ($self, $c, $type) = @_;

  my $now = DateTime->now;
  my $beginningOfMonth = DateTime->new(year => $now->year,
                                       month => $now->month,
                                       day => 1);
  my $endOfMonth = DateTime->new(year => $now->year,
                                 month => $now->month,
                                 day => 1);
  $endOfMonth->add(month => 1);

  my @transactions = $c->model('MoneyTraqDB::Transactions')->search({
                                                                     cancelled => 0,
                                                                     dat_valid => {
                                                                                   '>=' => $beginningOfMonth->date,
                                                                                   '<' => $endOfMonth->date
                                                                                  },
                                                                     transaction_type_id => $type,
                                                                    });
  return \@transactions;
}

sub ValidateTransactionData {
  my $data = shift;

  return exists $data->{transaction_type_id} &&
    exists $data->{account_id} &&
      exists $data->{description} &&
        exists $data->{dat_valid};
}

sub ValidateTransactionDetailData {
  my $data = shift;

  return exists $data->{transaction_id} &&
    exists $data->{account_id} &&
      exists $data->{amount};
}

sub TransactionExists {
  my ($c, $transaction_id) = @_;

  return defined $c->model('MoneyTraqDB::Transactions')->find({id => $transaction_id});
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
