package MoneyTraq::Schema::Roles;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("roles");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "role",
  { data_type => "TEXT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:emlfLCJ5kd4aM8QnjhhuCA

__PACKAGE__->has_many(user_roles => 'MoneyTraq::Schema::UserRoles', 'role_id');
__PACKAGE__->many_to_many(users => 'user_roles', 'user');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
