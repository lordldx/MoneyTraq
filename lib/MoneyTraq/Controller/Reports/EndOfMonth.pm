package MoneyTraq::Controller::Reports::EndOfMonth;

use strict;
use warnings;
use base qw/Catalyst::Controller::HTML::FormFu/;
use DateTime;

use constant TRANSACTION_TYPE_INCOME => scalar 1;
use constant TRANSACTION_TYPE_EXPENSE => scalar 2;

use constant ACCOUNT_ID_LORENZO => scalar 1;
use constant ACCOUNT_ID_TINEKE => scalar 2;
use constant ACCOUNT_ID_GEZAMELIJK => scalar 3;

=head1 NAME

MoneyTraq::Controller::Reports::EndOfMonth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index 

=cut

sub index :Path :FormConfig('reports/endofmonth.yml') :Args(0) {
    my ($self, $c) = @_;

    my $month;
    my $year;

    my $form = $c->stash->{form};
    if ($form->submitted_and_valid) {
      $year = $form->param_value('year');
      $month = $form->param_value('month');
    } else {
      # generate report of last month by default
      my $d = DateTime->now;
      $d->subtract(months => 1);
      $year = $d->year;
      $month = $d->month;

      $form->get_field('year')->default($year);
      $form->get_field('month')->default($month);
    }

    my $begindate = DateTime->new(year => $year,
                                  month => $month,
                                  day => 1);
    my $enddate = DateTime->new(year => $year,
                                month => $month,
                                day => 1);
    $enddate->add(months => 1);

    # make sure we have a detail for all accounts (except gezamelijk of course)
    my @accounts = $c->model("MoneyTraqDB::Accounts")->search({id => {'!=' => ACCOUNT_ID_GEZAMELIJK}});

    # calculate expenses
    my @expenses = $c->model("MoneyTraqDB::Transactions")->search({
                                                                   dat_valid => { '>=' => $begindate->date,
                                                                                  '<' => $enddate->date },
                                                                   transaction_type_id => TRANSACTION_TYPE_EXPENSE,
                                                                   account_id => ACCOUNT_ID_GEZAMELIJK,
                                                                   cancelled => 0
                                                                  });
    my $expenses = 0; # expenses for "Gezamelijke rekening"
    my %expenses_detail; # who payed for the expenses for "Gezamelijke rekening"
    $expenses_detail{$_->description} = 0 foreach (@accounts);
    foreach my $ex (@expenses) {
      foreach my $detail ($ex->details->all) {
        $expenses_detail{$detail->account->description} += $detail->amount;
        $expenses += $detail->amount;
      }
    }

    # calculate income
    my @incomes = $c->model("MoneyTraqDB::Transactions")->search({
                                                                  dat_valid => { '>=' => $begindate->date,
                                                                                 '<' => $enddate->date },
                                                                  transaction_type_id => TRANSACTION_TYPE_INCOME,
                                                                  account_id => ACCOUNT_ID_GEZAMELIJK,
                                                                  cancelled => 0
                                                                 });
    my $income = 0;   # income for "Gezamelijke rekening"
    my %income_detail; # who received the income for "Gezamelijke rekening"
    $income_detail{$_->description} = 0 foreach (@accounts);
    foreach my $in (@incomes) {
      foreach my $detail ($in->details->all) {
        $income_detail{$detail->account->description} += $detail->amount;
        $income += $detail->amount;
      }
    }

    # calculate result
    my %results;
    my %results_corrected;
    while (my ($k, $v) = each %income_detail) {
      my $pct = 0.0;
      $pct = $v / $income unless $income == 0;
      $results{$k} = $expenses * $pct;
    }
    while (my ($k, $v) = each %results) {
      $results_corrected{$k} = $expenses_detail{$k} - $v;
    }

    # add variables to stash
    $c->stash(
              expenses => $expenses,
              expenses_detail => \%expenses_detail,
              income => $income,
              income_detail => \%income_detail,
              results => \%results,
              results_corrected => \%results_corrected
             );

    $c->stash->{template} = 'reports/endofmonth.tt2';
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
