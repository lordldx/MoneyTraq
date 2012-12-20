package MoneyTraq::Controller::Settings::UserSettings;

use strict;
use warnings;
use parent qw/Catalyst::Controller::HTML::FormFu/;

=head1 NAME

MoneyTraq::Controller::Settings::UserSettings - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) :FormConfig('settings/usersettings.yml') {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form};

    # personal info
    $form->get_field('first_name')->default($c->user->first_name);
    $form->get_field('last_name')->default($c->user->last_name);

    # defaults
    my @accountsObj = $c->model('MoneyTraqDB::Accounts')->all;
    my @source_accounts;
    my @target_accounts;
    foreach (@accountsObj) {
      my $hs = {
               value => $_->id,
               label => $_->description,
              };
      $hs->{attributes}{selected} = 'selected' if $_->id == $c->user->settings->default_source_account->id;
      push @source_accounts, $hs;

      my $ht = {
                value => $_->id,
                label => $_->description,
               };
      $ht->{attributes}{selected} = 'selected' if $_->id == $c->user->settings->default_target_account->id;
      push @target_accounts, $ht;
    }
    $form->get_field('default_source_account')->options(\@source_accounts);
    $form->get_field('default_target_account')->options(\@target_accounts);

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
    $form->get_field('default_transaction_type')->options(\@types);

    # password
    # nothing to do here

    $c->stash->{template} = 'settings/usersettings.tt2';
}

sub savePersonalInfo :Local Args(2) {
  my ($self, $c, $first_name, $last_name) = @_;

  # get params
  if (validateNotEmpty($c, 'first_name', $first_name) &&
      validateNotEmpty($c, 'last_name', $last_name)) {
    # update DB
    my $user = $c->model('MoneyTraqDB::Users')->find({id => $c->user->id});
    $user->update({
                   first_name => $first_name,
                   last_name => $last_name
                  });
    $c->flash->{message} = 'Personal info changed';
  }

  $c->response->redirect($c->uri_for('/settings/usersettings'));
}

sub saveDefaults :Local Args(3) {
  my ($self, $c, $sa, $ta, $tt) = @_;

  if (validateNotEmpty($c, 'default_source_account', $sa) &&
      validateNotEmpty($c, 'default_target_account', $ta) &&
      validateNotEmpty($c, 'default_transaction_type', $tt)) {
    my $settings = $c->model('MoneyTraqDB::UserSettings')->find({user_id => $c->user->id});
    $settings->update({
                       default_source_account => $sa,
                       default_target_account => $ta,
                       default_transaction_type => $tt
                      });
    $c->flash->{message} = 'Default changed';
  }

  $c->response->redirect($c->uri_for('/settings/usersettings'));
}

sub savePassword :Local Args(3) {
  my ($self, $c, $old, $new1, $new2) = @_;

  if (validateNotEmpty($c, 'old_pwd', $old) &&
      validateNotEmpty($c, 'new_pwd_1', $new1) &&
      validateNotEmpty($c, 'new_pwd_2', $new2)) {
    if ($old eq $c->user->password) {
      if ($new1 eq $new2) {
        my $user = $c->model('MoneyTraqDB::Users')->find({id => $c->user->id});
        $user->update({
                       password => $new1
                      });
        $c->flash->{message} = 'Password changed';
      } else {
        $c->flash->{error} = 'Typed two different values for "new password"';
      }
    } else {
      $c->flash->{error} = 'Incorrect old password';
    }
  }
  $c->response->redirect($c->uri_for('/settings/usersettings'));
}

sub validateNotEmpty :Private {
  my ($c, $param_name, $param) = @_;

  return 1 if defined $param && $param ne '';

  $c->flash->{error} = "$param_name is a mandatory field\n";
  return 0;
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
