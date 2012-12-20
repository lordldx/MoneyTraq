package MoneyTraq::Schema::TransactionDetails;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transaction_details");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "transaction_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "account_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "amount",
  { data_type => "FLOAT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QHTZwC97xFe0BGkP/dx/3Q
__PACKAGE__->belongs_to(transaction => 'MoneyTraq::Schema::Transactions', 'transaction_id');
__PACKAGE__->belongs_to(account => 'MoneyTraq::Schema::Accounts', 'account_id');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
