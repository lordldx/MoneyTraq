package MoneyTraq::View::TT;

use strict;
use base 'Catalyst::View::TT';
use MoneyTraq;

__PACKAGE__->config({
                     INCLUDE_PATH => [
                                      MoneyTraq->path_to( 'root', 'src' ),
                                      MoneyTraq->path_to( 'root', 'lib' ),
                                      MoneyTraq->path_to( 'root', 'static' )
                                     ],
                     PRE_PROCESS  => 'config/main',
                     WRAPPER      => 'site/wrapper',
                     ERROR        => 'error.tt2',
                     TEMPLATE_EXTENSION => '.tt2',
                     TIMER        => 0
                    });

=head1 NAME

MoneyTraq::View::TT - Catalyst TTSite View

=head1 SYNOPSIS

See L<MoneyTraq>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

