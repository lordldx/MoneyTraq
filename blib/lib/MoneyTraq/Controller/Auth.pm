package MoneyTraq::Controller::Auth;

use strict;
use warnings;
use parent 'Catalyst::Controller::HTML::FormFu';

=head1 NAME

MoneyTraq::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) {
  my ( $self, $c ) = @_;

  $c->response->redirect($c->uri_for('login'));
}

sub login :Local :FormConfig {
  my ( $self, $c ) = @_;

  if (!$c->user_exists()) {
    my $form = $c->stash->{form};
    if ($form->submitted_and_valid) {
      my $username = $form->param_value('username');
      my $password = $form->param_value('password');

      if (!$c->authenticate({ username => $username, password => $password })) {
        $c->stash->{error} = "Bad username or password.";
        $c->stash->{template} = 'login.tt2';
        return;
      }
    } else {
      $c->stash->{template} = 'login.tt2';
      return;
    }
  }

  $c->response->redirect($c->uri_for('/main'));
}

sub logout :Path('logout') :Args(0) {
  my ( $self, $c ) = @_;

  $c->logout;
  $c->response->redirect($c->uri_for('login'));
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
