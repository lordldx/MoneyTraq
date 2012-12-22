package MoneyTraq::Schema::TransactionsTransactionAttributes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transactions_transaction_attributes");
__PACKAGE__->add_columns(
  "transaction_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "transaction_attribute_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("transaction_id", "transaction_attribute_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3l49sMd0zRI19lN44Al5VA
__PACKAGE__->belongs_to(transactions => 'MoneyTraq::Schema::Transactions', 'transaction_id');
__PACKAGE__->belongs_to(attributes => 'MoneyTraq::Schema::TransactionAttributes', 'transaction_attribute_id');


# You can replace this text with custom content, and it will be preserved on regeneration
1;
