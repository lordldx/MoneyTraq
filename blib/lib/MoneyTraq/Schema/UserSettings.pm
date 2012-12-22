package MoneyTraq::Schema::UserSettings;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("user_settings");
__PACKAGE__->add_columns(
  "user_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "default_transaction_type",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "default_target_account",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "default_source_account",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("user_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tgLhHoLBxLkPQ942/eoYDg

__PACKAGE__->belongs_to(default_target_account => 'MoneyTraq::Schema::Accounts', 'default_target_account');
__PACKAGE__->belongs_to(default_source_account => 'MoneyTraq::Schema::Accounts', 'default_source_account');
__PACKAGE__->belongs_to(default_transaction_type => 'MoneyTraq::Schema::TransactionTypes', 'default_transaction_type');

__PACKAGE__->belongs_to(user => 'MoneyTraq::Schema::Users', 'user_id');


# You can replace this text with custom content, and it will be preserved on regeneration
1;
