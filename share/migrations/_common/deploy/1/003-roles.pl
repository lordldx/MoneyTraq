use strict;
use warnings;
use DBIx::Class::Migration::RunScript;

migrate {
  my $ctx = shift;

  my $rolesRS = $ctx->schema->resultset('Role');

  $rolesRS->create({
                    id => 1,
                    role => "user"
                   });
  $rolesRS->create({
                    id => 2,
                    role => "admin"
                   });
}
