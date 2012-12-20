package MoneyTraq::Controller::TransactionDetails;

use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';

=head1 NAME

MoneyTraq::Controller::TransactionDetails - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub add :Path('/transactiondetails/add') :Params(1) :FormConfig('transactiondetails/form.yml') {
  my ($self, $c, $trans_id) = @_;

  my $form = $c->stash->{form};

  if ($form->submitted_and_valid) {
    my $detail = $c->model('MoneyTraqDB::TransactionDetails')->create({
                                                                       transaction_id => $trans_id,
                                                                       account_id => $form->param_value('account'),
                                                                       amount => $form->param_value('amount')
                                                                      });
    my $dat_valid = $detail->transaction->dat_valid;

    if ($form->param_value('submit_plus_new') == 1) {
      $c->flash->{message} = "Transaction detail successfully added";
      $c->response->redirect($c->uri_for("/transactiondetails/add/$trans_id"));
    } else {
      $c->flash->{message} = "Transaction successfully added";
      $c->flash->{new_id} = $trans_id;
      $c->response->redirect($c->uri_for('/main/' . $dat_valid->month . '/' . $dat_valid->year));
    }
  } else {
    # fill the form
    my @accountsObj = $c->model('MoneyTraqDB::Accounts')->all;
    my @accounts;
    foreach (@accountsObj) {
      my $h = {
               value => $_->id,
               label => $_->description,
              };
      $h->{attributes}{selected} = 'selected' if $_->id == $c->user->settings->default_source_account->id;
      push @accounts, $h;
    }
    $form->get_field('account')->options(\@accounts);
    $c->stash->{template} = 'transactiondetails/form.tt2';
  }
}

sub edit :Path('/transactiondetails/edit') :Params(1) :FormConfig('transactiondetails/form.yml') {
  my ($self, $c, $detail_id) = @_;

  my $form = $c->stash->{form};

  if ($form->submitted_and_valid) {
    my $detail = $c->model('MoneyTraqDB::TransactionDetails')->find({id => $detail_id});
    $detail->update({
                     account_id => $form->param_value('account'),
                     amount => $form->param_value('amount')
                    });

    $c->flash->{message} = "Transaction detail successfully edited";
    if ($form->param_value('submit_plus_new') == 1) {
      my $trans_id = $detail->transaction_id;
      $c->response->redirect($c->uri_for("/transactiondetails/add/$trans_id"));
    } else {
      my $dat_valid = $detail->transaction->dat_valid;
      $c->response->redirect($c->uri_for('/main/' . $dat_valid->month . '/' . $dat_valid->year));
    }
  } else {
    my $detail = $c->model('MoneyTraqDB::TransactionDetails')->find({id => $detail_id});
    if (!defined $detail) {
      $c->flash->{error} = 'Could not find the transaction detail you requested';
      $c->response->redirect($c->uri_for('/main'));
    }

    # fill the form
    my @accountsObj = $c->model('MoneyTraqDB::Accounts')->all;
    my @accounts;
    foreach my $account (@accountsObj) {
      my $h = {
               value => $account->id,
               label => $account->description
              };
      if ($account->id == $detail->account->id) {
        $h->{attributes}{selected} = 'selected';
      }
      push @accounts, $h;
    }

    my $account_elem = $form->get_field('account');
    my $amount_elem = $form->get_field('amount');
    $account_elem->options(\@accounts);
    $amount_elem->default($detail->amount);
    $c->stash->{template} = 'transactiondetails/form.tt2';
  }
}

sub delete :Path('/transactiondetails/delete') :Params(1) {
  my ($self, $c, $detail_id) = @_;

  $c->model('MoneyTraqDB::TransactionDetails')->find({id => $detail_id})->delete;
  $c->response->redirect($c->uri_for('/main'));
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
