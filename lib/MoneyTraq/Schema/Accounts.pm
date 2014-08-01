package MoneyTraq::Schema::Accounts;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("accounts");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "description",
  { data_type => "TEXT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-03-13 10:42:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QSvY4becYYkobm+LnlcikQ
__PACKAGE__->has_many(transactions => 'MoneyTraq::Schema::Transactions', 'account_id');

__PACKAGE__->has_many(transaction_details => 'MoneyTraq::Schema::TransactionDetails', 'account_id');

__PACKAGE__->has_many(user_settings_target => 'MoneyTraq::Schema::UserSettings', 'default_target_account');
__PACKAGE__->has_many(user_settings_source => 'MoneyTraq::Schema::UserSettings', 'default_source_account');


# You can replace this text with custom content, and it will be preserved on regeneration

sub TO_JSON {
	my $self = shift;

	return {
		id => $self->id,
		description => $self->description
	};
}

1;
