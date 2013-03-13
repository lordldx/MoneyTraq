package MoneyTraq::Controller::Reports::Listing;

use strict;
use warnings;
use base qw/Catalyst::Controller::HTML::FormFu Catalyst::Controller::BindLex/;

=head1 NAME

MoneyTraq::Controller::Reports::Listing - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :Args(0) :FormConfig('reports/listing.yml') {
  my ( $self, $c ) = @_;

  $self->fillForm($c);

  my $form = $c->stash->{form};
  if ($form->submitted_and_valid) {
    $self->getResults($c);
  }

  $c->stash->{template} = 'reports/listing.tt2';
}

sub fillForm : Private {
  my ($self, $c) = @_;

  my $form = $c->stash->{form};

  my @typesObj = $c->model('MoneyTraqDB::TransactionTypes')->all;
  my @types;
  push @types, [$_->id, $_->description] foreach (@typesObj);
  $form->get_field('transaction_type')->options(\@types);

  my @accountsObj = $c->model('MoneyTraqDB::Accounts')->all;
  my @accounts;
  push @accounts, [$_->id, $_->description] foreach (@accountsObj);
  $form->get_field('account')->options(\@accounts);

  my @attributesObj = $c->model('MoneyTraqDB::TransactionAttributes')->all;
  my @attributes;
  push @attributes, [$_->id, $_->description] foreach (@attributesObj);
  $form->get_field('attributes')->options(\@attributes);
}

sub getResults : Private {
    my ($self, $c) = @_;
    my $form = $c->stash->{form};

    my %where;

    my @transaction_types = $form->param_list('transaction_type');
    $where{transaction_type_id} = \@transaction_types if @transaction_types;

    my @accounts = $form->param_list('account');
    $where{account_id} = \@accounts if @accounts;

    my $from = $form->param_value('dat_valid_from');
    my $until = $form->param_value('dat_valid_until');
    if (defined $from || defined $until) {
	my ($fromPart, $untilPart);
	$where{dat_valid} = ['-and'];
	push @{$where{dat_valid}}, {'>=', $from->date} if defined $from;
	push @{$where{dat_valid}}, {'<=', $until->date} if defined $until;
    }

    my @attributes = $form->param_list('attributes');
    $where{'transaction_attributes.transaction_attribute_id'} = \@attributes if @attributes;

    # actual query
    my @transactions : Stashed = $c->model('MoneyTraqDB::Transactions')->search(\%where,
										{
										    join => 'transaction_attributes',
										    order_by => 'dat_valid DESC, dat_entry DESC',
										    group_by => 'me.id'
										});
    
    # calculate totals, generate human-readable dates, and append them to each transaction object
    my $total_in : Stashed = 0;
    my $total_out : Stashed = 0;
    foreach my $trans (@transactions) {
	my $trans_total = 0;
	foreach my $detail ($trans->details->all) {
	    $trans_total += $detail->amount;
	}
	$trans->{total} = $trans_total;
	$trans->{dat_valid_hr} = $trans->dat_valid->strftime('%d/%m/%Y');
	
	$total_in += $trans_total if $trans->transaction_type_id == 1;
	$total_out += $trans_total if $trans->transaction_type_id == 2;
    }
}

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
