package MoneyTraq::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

MoneyTraq::Controller::Root - Root Controller for MoneyTraq

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->redirect($c->uri_for('/main'));
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->status('404');
    $c->stash->{template} = 'not_found.tt2';
}

# auto method: redirect to login unless logged in
sub auto :Private {
  my ($self, $c) = @_;

  return 1 if $c->controller eq $c->controller('Auth') || $c->user_exists;
  $c->response->redirect($c->uri_for('/auth/login'));
  return 0;
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;