package MoneyTraq::Schema::Users;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "username",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "password",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "first_name",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "last_name",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "active",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8WeatIUuuN9gzfHoeLWCZA

__PACKAGE__->has_many(user_roles => 'MoneyTraq::Schema::UserRoles', 'user_id');
__PACKAGE__->many_to_many(roles => 'user_roles', 'role');

__PACKAGE__->has_many(transactions => 'MoneyTraq::Schema::Transactions', 'user_id');

__PACKAGE__->has_one(settings => 'MoneyTraq::Schema::UserSettings');


# You can replace this text with custom content, and it will be preserved on regeneration
1;
