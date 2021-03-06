package MoneyTraq::Model::MoneyTraqDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

# try to determine location of db. Yes, you may shoot me for this.
my $dbLocation = __FILE__;
$dbLocation =~ s/lib\/MoneyTraq\/Model\/MoneyTraqDB.pm/moneytraq.db/;

__PACKAGE__->config(
    schema_class => 'MoneyTraq::Schema',
    connect_info => [
        'dbi:SQLite:' . $dbLocation,
    ],
);

=head1 NAME

MoneyTraq::Model::MoneyTraqDB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<MoneyTraq>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<MoneyTraq::Schema>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
