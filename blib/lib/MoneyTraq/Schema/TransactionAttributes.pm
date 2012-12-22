package MoneyTraq::Schema::TransactionAttributes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transaction_attributes");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "description",
  { data_type => "TEXT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RUQEO60oeOC+7cZbq95jvw
__PACKAGE__->has_many(transactions_attributes => 'MoneyTraq::Schema::TransactionsTransactionAttributes', 'transaction_attribute_id');
__PACKAGE__->many_to_many(transactions => 'transactions_attributes', 'transactions');


# You can replace this text with custom content, and it will be preserved on regeneration
1;
