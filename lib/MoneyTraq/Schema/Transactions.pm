package MoneyTraq::Schema::Transactions;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("transactions");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "transaction_type_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "account_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "user_id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "description",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "dat_entry",
  { data_type => "DATETIME", is_nullable => 0, size => undef },
  "dat_valid",
  { data_type => "DATE", is_nullable => 0, size => undef },
  "cancelled",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-01-31 15:50:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rAz3uuEUeGsschtHIBOufw

__PACKAGE__->belongs_to(type => 'MoneyTraq::Schema::TransactionTypes', 'transaction_type_id');
__PACKAGE__->belongs_to(account => 'MoneyTraq::Schema::Accounts', 'account_id');
__PACKAGE__->belongs_to(registrar => 'MoneyTraq::Schema::Users', 'user_id');

__PACKAGE__->has_many(details => 'MoneyTraq::Schema::TransactionDetails', 'transaction_id');

__PACKAGE__->has_many(transaction_attributes => 'MoneyTraq::Schema::TransactionsTransactionAttributes', 'transaction_id');
__PACKAGE__->many_to_many(attributes => 'transaction_attributes', 'attributes');


# You can replace this text with custom content, and it will be preserved on regeneration

sub getTotal {
  my $self = shift;

  my $total = 0;
  foreach my $detail ($self->details->all) {
    $total += $detail->amount;
  }

  return $total;
}
1;
