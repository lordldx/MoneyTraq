package MoneyTraq::Controller::Main;

use strict;
use warnings;
use base qw/Catalyst::Controller/;
use DateTime;


sub index : Path('/main') {
  my ( $self, $c, $month, $year ) = @_;

  my $period;
  if (defined $month && defined $year) {
    $period = new DateTime(year => $year,
                           month => $month,
                           day => 1);
  } else {
    $period = DateTime->now;
  }

  my $prev = new DateTime(year => $period->year,
                          month => $period->month,
                          day => 1);
  my $next = new DateTime(year => $period->year,
                          month => $period->month,
                          day => 1);
  $prev->subtract(months => 1);
  $next->add(months => 1);

  my $bom = DateTime->new(year => $period->year,
                          month => $period->month,
                          day => 1);

  my $eom = DateTime->new(year => $period->year,
                          month => $period->month,
                          day => 1);
  $eom->add(months => 1);

  my @all_transactions = $c->model('MoneyTraqDB::Transactions')->search({
                                                                         cancelled => 0,
                                                                         dat_valid => {
                                                                                       '>=' => $bom->date,
                                                                                       '<' => $eom->date
                                                                                      },
                                                                        },
                                                                        {
                                                                         order_by => 'dat_valid DESC, dat_entry DESC'
                                                                        });

  my @transactions;
  if (defined $c->stash->{new_id}) {
    # display transaction that was just added + ten older ones (max)
    my $newest_trans = $c->model('MoneyTraqDB::Transactions')->search({id => $c->stash->{new_id}})->first;
    @transactions = $c->model('MoneyTraqDB::Transactions')->search({
                                                                    cancelled => 0,
                                                                    dat_valid => {'<=' => $newest_trans->dat_valid}
                                                                    # using <= here so that newest_trans will also be in the selection
                                                                   },
                                                                   {
                                                                    order_by => 'dat_valid DESC, dat_entry DESC'
                                                                   });
    my $end = (scalar @transactions) - 1;
    $end = 9 if $end > 9;
    @transactions = @transactions[0..$end];
  } else {
    # display transactions in standard view (first ten (max))
    my $end = (scalar @all_transactions) - 1;
    $end = 9 if $end > 9;
    @transactions = @all_transactions[0..$end];
  }

  # calculate totals and append to each transaction object
  my $total_in = 0;
  my $total_out = 0;
  foreach my $trans (@all_transactions) {
    $trans->{total} = $trans->getTotal();
    $total_in += $trans->{total} if $trans->transaction_type_id == 1;
    $total_out += $trans->{total} if $trans->transaction_type_id == 2;
  }

  foreach my $trans (@transactions) {
    $trans->{total} = $trans->getTotal();
    $trans->{dat_valid_hr} = $trans->dat_valid->strftime('%d/%m/%Y');
  }

  # put vars onto the stash:
  $c->stash(
            period => $period,
            prev => $prev,
            next => $next,
            transactions => \@transactions,
            total_in => $total_in,
            total_out => $total_out
           );

  $c->stash->{template} = 'main.tt2';
}

sub all : Path('/main/all') {
  my ( $self, $c, $month, $year ) = @_;

  my $period;
  if (defined $month && defined $year) {
    $period = new DateTime(year => $year,
                           month => $month,
                           day => 1);
  } else {
    $period = DateTime->now;
  }

  my $prev = new DateTime(year => $period->year,
                          month => $period->month,
                          day => 1);
  my $next = new DateTime(year => $period->year,
                          month => $period->month,
                          day => 1);
  $prev->subtract(months => 1);
  $next->add(months => 1);

  my $bom = DateTime->new(year => $period->year,
                          month => $period->month,
                          day => 1);

  my $eom = DateTime->new(year => $period->year,
                          month => $period->month,
                          day => 1);
  $eom->add(months => 1);

  my @all_transactions = $c->model('MoneyTraqDB::Transactions')->search({
                                                                         cancelled => 0,
                                                                         dat_valid => {
                                                                                       '>=' => $bom->date,
                                                                                       '<' => $eom->date
                                                                                      },
                                                                        },
                                                                        {
                                                                         order_by => 'dat_valid DESC, dat_entry DESC'
                                                                        });

  # calculate totals and append to each transaction object
  my $total_in = 0;
  my $total_out = 0;
  foreach my $trans (@all_transactions) {
    $trans->{dat_valid_hr} = $trans->dat_valid->strftime('%d/%m/%Y');
    $trans->{total} = $trans->getTotal();
    $total_in += $trans->{total} if $trans->transaction_type_id == 1;
    $total_out += $trans->{total} if $trans->transaction_type_id == 2;

  }

  # put vars onto the stash:
  $c->stash(
            period => $period,
            prev => $prev,
            next => $next,
            transactions => \@all_transactions,
            total_in => $total_in,
            total_out => $total_out
           );

  $c->stash->{template} = 'main.tt2';
}

  1;
