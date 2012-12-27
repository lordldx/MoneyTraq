package MoneyTraq::Controller::Setup;
use Cwd;
use Moose;
use namespace::autoclean;
use DBIx::Class::Migration;
use MoneyTraq::Model::MoneyTraqDB;
use MoneyTraq::Schema::Roles;

BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; }

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
    if (!$self->DbFileExists) {
      $c->response->redirect($c->uri_for('prerequisites'));
    } elsif (!$self->DbContainsAccounts($c)) {
      $c->response->redirect($c->uri_for('createaccounts'));
    } elsif (!$self->DbContainsUsers($c)) {
      $c->response->redirect($c->uri_for('createusers'));
    } else {
      $c->response->redirect($c->uri_for('/'));
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

  my $migration = DBIx::Class::Migration->new(schema => MoneyTraq::Model::MoneyTraqDB->new->schema);
  if ($migration->install) {
    $c->response->redirect($c->uri_for('createaccounts'));
  } else {
    $c->flash->{error} = "Could not create the database file";
    $c->response->redirect($c->uri_for('index'));
  }
}

sub createaccounts :Local :FormConfig {
  my ($self, $c) = @_;

  my $form = $c->stash->{form};

  if ($form->submitted_and_valid) {
    $c->model('MoneyTraqDB::Accounts')->create({description => $form->param_value('description')});
  }

  @{$c->stash->{accounts}} = $c->model('MoneyTraqDB::Accounts')->all;
  $c->stash->{template} = 'setup/createaccounts.tt2';
}

sub createusers :Local :FormConfig {
  my ($self, $c) = @_;

  my $form = $c->stash->{form};

  if ($form->submitted_and_valid) {
      my $user = $c->model('MoneyTraqDB::Users')->create({
	  username => $form->param_value('username'),
	  password => $form->param_value('password'),
	  first_name => $form->param_value('first_name'),
	  last_name => $form->param_value('last_name'),
	  active => 1
							 });
      $user->add_to_roles({id => $form->param_value('role_id')});
      $user->settings({
	  default_transaction_type => $form->param_value('default_transaction_type'),
	  default_target_account => $form->param_value('default_target_account'),
	  default_source_account => $form->param_value('default_source_account')
		      });
  }

  @{$c->stash->{users}} = $c->model('MoneyTraqDB::Users')->all;
  $c->stash->{has_administrator} = $c->model('MoneyTraqDB::Users')->search_related_rs('user_roles', {role_id => $Roles::ADMIN})->count > 0;
  $c->stash->{template} = 'setup/createusers.tt2';
}

sub IsNotSetUp :Private {
  my ($self, $c) = @_;

  # has the db been initialized
  return 1 unless $self->DbFileExists;

  # Does the db contain accounts?
  return 1 unless $self->DbContainsAccounts($c);

  # Does the db contain users?
  return 1 unless $self->DbContainsUsers($c);

  return 0;
}

sub DbFileExists :Private {
  return -f 'moneytraq.db';
}

sub DbContainsUsers :Private {
  my ($self, $c) = @_;

  return $c->model('MoneyTraqDB::Users')->count > 0;
}

sub DbContainsAccounts :Private {
  my ($self, $c) = @_;

  return $c->model('MoneyTraqDB::Accounts')->count > 0;
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
