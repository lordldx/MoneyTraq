use strict;
use warnings;
use DBIx::Class::Migration::RunScript;

migrate {
  my $ctx = shift;

  my $transactionTypesRS = $ctx->schema->resultset('TransactionType');

  $transactionTypesRS->create({
                               id => 1,
                               description => "Income"
                              });
  $transactionTypesRS->create({
                               id => 2,
                               description => "Expense"
                              });
}
