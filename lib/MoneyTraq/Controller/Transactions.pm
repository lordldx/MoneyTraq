package MoneyTraq::Controller::Transactions;

use strict;
use warnings;

use parent 'Catalyst::Controller::HTML::FormFu';

=head1 NAME

MoneyTraq::Controller::Transactions - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 enter

=cut

sub add :Path('/transactions/add') :FormConfig('transactions/form.yml') :Args(0) {
  my ($self, $c) = @_;

  my $form = $c->stash->{form};

  if ($form->submitted_and_valid) {
    my $account = $form->param_value('account');
    my $dat_valid = $form->param_value('dat_valid');
    my $descr = $form->param_value('description');
    my $type = $form->param_value('transaction_type');

    # add data to db
    #  - transaction
    my $transaction = $c->model('MoneyTraqDB::Transactions')->create({
                                                                      transaction_type_id => $type,
                                                                      account_id => $account,
                                                                      description => $descr,
                                                                      dat_entry => $c->datetime(),
                                                                      dat_valid => $dat_valid,
                                                                      cancelled => 0,
                                                                      user_id => $c->user()->id,
                                                                     });
    #  - transaction_attributes
    foreach ($form->param_list('attributes')) {
      $c->model('MoneyTraqDB::TransactionsTransactionAttributes')->create({
                                                                           transaction_id => $transaction->id,
                                                                           transaction_attribute_id => $_
                                                                          });
    }

    $c->response->redirect($c->uri_for('/transactiondetails/add/' . $transaction->id));
    # $c->response->redirect($c->uri_for('/main/' . $dat_valid->month . '/' . $dat_valid->year));
  } else {
    # populate the form

    my @typesObj = $c->model('MoneyTraqDB::TransactionTypes')->all;
    my @types;
    foreach (@typesObj) {
      my $h = {
               value => $_->id,
               label => $_->description,
              };
      $h->{attributes}{selected} = 'selected' if $_->id == $c->user->settings->default_transaction_type->id;
      push @types, $h;
    }
    $form->get_field('transaction_type')->options(\@types);

    my @accountsObj = $c->model('MoneyTraqDB::Accounts')->all;
    my @accounts;
    foreach (@accountsObj) {
      my $h = {
               value => $_->id,
               label => $_->description,
              };
      $h->{attributes}{selected} = 'selected' if $_->id == $c->user->settings->default_target_account->id;
      push @accounts, $h;
    }
    $form->get_field('account')->options(\@accounts);

    my @attributesObj = $c->model('MoneyTraqDB::TransactionAttributes')->all;
    my @attributes;
    push @attributes, [$_->id, $_->description] foreach (@attributesObj);
    $form->get_field('attributes')->options(\@attributes);

    $c->stash->{template} = 'transactions/form.tt2';
  }
}

sub delete :Path('/transactions/delete') :Args(1) {
  my ($self, $c, $transid) = @_;

  my $trans = $c->model('MoneyTraqDB::Transactions')->find({id => $transid})->update({cancelled => 1});
  $c->response->redirect($c->uri_for('/main'));
}

sub edit :Path('/transactions/edit') :Args(1) :FormConfig('transactions/form.yml') {
  my ($self, $c, $trans_id) = @_;

  my $form = $c->stash->{form};

  if ($form->submitted_and_valid) {
    my $account = $form->param_value('account');
    my $dat_valid = $form->param_value('dat_valid');
    my $descr = $form->param_value('description');
    my $type = $form->param_value('transaction_type');

    my $trans = $c->model('MoneyTraqDB::Transactions')->find({id => $trans_id});
    $trans->update({
                    transaction_type_id => $type,
                    account_id => $account,
                    description => $descr,
                    dat_valid => $dat_valid,
                   });

    # edit attributes (insert/delete)
    my @attributes = $form->param_list('attributes');
    my %hattributes;
    $hattributes{$_}++ foreach (@attributes);

    my @oldattributes = $trans->attributes->all;
    my %holdattributes;
    $holdattributes{$_->id}++ foreach (@oldattributes);

    # -- remove attributes that are no longer selected
    foreach my $attrid (keys %holdattributes) {
      if (!defined $hattributes{$attrid}) { # no longer selected => delete it
        $c->model('MoneyTraqDB::TransactionsTransactionAttributes')->find({
                                                                           transaction_id => $trans->id,
                                                                           transaction_attribute_id => $attrid
                                                                          })->delete;
      }
    }

    # -- add attributes that were previously not selected
    foreach my $attrid (keys %hattributes) {
      if (!defined $holdattributes{$attrid}) { # was previously not selected => add it
        $c->model('MoneyTraqDB::TransactionsTransactionAttributes')->create({
                                                                             transaction_id => $trans->id,
                                                                             transaction_attribute_id => $attrid
                                                                            });
      }
    }

    $c->response->redirect($c->uri_for('/main'));
  } else {
    # populate the form
    # and fill in current values
    my $trans = $c->model('MoneyTraqDB::Transactions')->find({id => $trans_id});

    my @typesObj = $c->model('MoneyTraqDB::TransactionTypes')->all;
    my @types;
    foreach my $type (@typesObj) {
      my $h = {value => $type->id,
               label => $type->description};
      if ($type->id == $trans->type->id) {
        $h->{attributes}{selected} = 'selected';
      }
      push @types, $h;
    }
    $form->get_field('transaction_type')->options(\@types);

    my @accountsObj = $c->model('MoneyTraqDB::Accounts')->all;
    my @accounts;
    foreach my $account (@accountsObj) {
      my $h = {value => $account->id,
               label => $account->description};
      if ($account->id == $trans->account->id) {
        $h->{attributes}{selected} = 'selected';
      }
      push @accounts, $h;
    }
    $form->get_field('account')->options(\@accounts);

    my @attributesObj = $c->model('MoneyTraqDB::TransactionAttributes')->all;
    my @attributes;
    my @selectedAttributes = $trans->attributes->all;
    my %hselectedAttributes;
    $hselectedAttributes{$_->id}++ foreach (@selectedAttributes);
    foreach my $attr (@attributesObj) {
      my $h = {value => $attr->id,
               label => $attr->description};
      if (defined $hselectedAttributes{$attr->id}) {
        $h->{attributes}{selected} = 'selected'; # TODO: run through $trans->attributes array
      }
      push @attributes, $h;
    }
    $form->get_field('attributes')->options(\@attributes);

    $form->get_field('description')->default($trans->description);
    $form->get_field('dat_valid')->default($trans->dat_valid);
    $c->stash->{template} = 'transactions/form.tt2';
  }
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
