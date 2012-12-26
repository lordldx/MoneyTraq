package MoneyTraq::Controller::Setup;
use Cwd;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MoneyTraq::Controller::Setup - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Step 1: CreateDB consists of three parts: creating the file, creating the schema and running the init script
    if (!$self->DbFileExists ||
        !$self->DbSchemaCreated ||
        !$self->DbIsInitialized) {
      $c->response->redirect($c->uri_for('prerequisites'));
    }
}

sub prerequisites :Local {
  my ($self, $c) = @_;

  $c->stash->{can_write} = (-w getcwd());
  $c->stash->{current_user} = getlogin;
  $c->stash->{current_dir} = getcwd;
  $c->stash->{template} = 'setup/prerequisites.tt2';
}

sub createdb :Local {
  my ($self, $c) = @_;

  open F, ">moneytraq.db";
  close F;

  if ($self->DbFileExists) {
    $c->response->redirect($c->uri_for('createschema'));
  } else {
    $c->flash->{error} = "Could not create the database file";
    $c->response->redirect($c->uri_for('index'));
  }
}

sub IsNotSetUp :Private {
  my ($self, $c) = @_;

  # is there a dbfile?
  return 1 unless $self->DbFileExists;

  # has the schema been created?
  return 1 unless $self->DbSchemaCreated;

  # has the db been initialized ?
  return 1 unless $self->DbIsInitialized;

  # Does the db contain accounts?
  return 1 unless $self->DbContainsAccounts;

  # Does the db contain users?
  return 1 unless $self->DbContainsUsers;

}

sub DbFileExists :Private {
  return -f 'moneytraq.db';
}

sub DbSchemaCreated :Private {
  return 0;
}

sub DbIsInitialized :Private {
  return 0;
}

sub DbContainsUsers :Private {
  return 0;
}

sub DbContainsAccounts :Private {
  return 0;
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
