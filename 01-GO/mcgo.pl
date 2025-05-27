#!/usr/bin/perl

# Joseph Ryan December, 2017
# updated to add long GO ID names May 31, 2024

use strict;
use warnings;
use List::Util 'shuffle';
use Data::Dumper;

our $VERSION = 0.02;

our $SEED = 420;
srand($SEED);
our $REPS = 10000;
our $MLIDS = 'MLIDS.txt';
our $GO_LONGNAMES = 'go_longnames.csv';

MAIN: {
    my $genome_go = $ARGV[0] or die "usage: $0 ML_GO TARGET_FILE\n";
    my $targets   = $ARGV[1] or die "usage: $0 ML_GO TARGET_FILE\n";
    my $rh_go = get_gohash($genome_go);
    my $rh_go_counts = get_go_counts($rh_go);
    my $rh_go_ln = get_longnames($GO_LONGNAMES);
    my $ra_mlids = get_ids($MLIDS);
    my $ra_ids = get_ids($targets);
    my $rh_c = get_counts($ra_ids,$rh_go);
    my $num_ids = scalar(@{$ra_ids});
    my @all_counts = ();
    for (1..$REPS) {
        my $ra_rand_ids = get_rand_ids($num_ids,$ra_mlids);
        my $rh_rc = get_counts($ra_rand_ids,$rh_go);
        push @all_counts, $rh_rc;
    }
    my $rh_pv = get_pvals($rh_c,\@all_counts);
    print_csv($rh_pv,$rh_c,$rh_go_ln,$rh_go_counts);
#    print_report($rh_pv,$rh_c,$rh_go_ln);
}

sub get_go_counts {
    my $rh_go = shift;
    my %data  = ();
    foreach my $rh_g (values %{$rh_go}) {
        foreach my $goid (keys %{$rh_g}) {
            $data{$goid}++;
        }
    }
    return \%data;
}

sub get_longnames {
    my $file = shift;
    my %data = ();
    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        chomp $line;
        my @ff = split /,/, $line;
        $data{$ff[0]} = $ff[1];
    }
    return \%data;
}

sub print_csv {
    my $rh_pv  = shift;
    my $rh_c   = shift;
    my $rh_ln  = shift;
    my $rh_g_c = shift;

    print "GOID,NUM_IN_QUERY,PERECENT_OF_CAT_IN_QUERY,PVAL,DESC\n";
    foreach my $id (sort {$rh_pv->{$a}->[1] <=> $rh_pv->{$b}->[1] ||
                          $rh_c->{$b} <=> $rh_c->{$a}} keys %{$rh_pv}) {
        my $go_descr = $rh_ln->{$id} || '';
        my $percent = $rh_c->{$id} / $rh_g_c->{$id};
        print "$id,$rh_c->{$id},$percent,$rh_pv->{$id}->[1],$go_descr\n";
    }
}

sub print_report {
    my $rh_pv = shift;
    my $rh_c  = shift;
    my $rh_ln = shift;

    my $count = 0;
    print "#: ID (num in query): pval (num x seen in random sets / total reps)\n";
    foreach my $id (sort {$rh_pv->{$a}->[1] <=> $rh_pv->{$b}->[1] ||
                          $rh_c->{$b} <=> $rh_c->{$a}} keys %{$rh_pv}) {
        $count++;
        my $go_descr = $rh_ln->{$id} || '';
        print "$count: $id ($rh_c->{$id}): pval=$rh_pv->{$id}->[1] ($rh_pv->{$id}->[0] / $REPS) -- $go_descr\n";
    }

}

sub get_pvals {
    my $rh_d = shift;
    my $ra_all = shift;
    my %gte = ();
    my %pv  = ();
    foreach my $rh_a (@{$ra_all}) {
        foreach my $goid (keys %{$rh_d}) {
            my $allcount = $rh_a->{$goid} || 0;
            $gte{$goid}++ if ($allcount >= $rh_d->{$goid});
        }
    }
    foreach my $goid (sort {$rh_d->{$b} <=> $rh_d->{$a}} keys %{$rh_d}) {
        if ($gte{$goid}) {
            my $p = $gte{$goid} / $REPS;
            $pv{$goid} = [$gte{$goid},$p];
        } else {
            $pv{$goid} = [0,0];
        }
    }
    return \%pv;
}

sub get_rand_ids {
    my $n = shift;
    my $ra_mlids = shift;
    my @rands = ();
    my @shuf = shuffle(@{$ra_mlids});
    for (my $i = 0; $i < $n; $i++) {
        push @rands, $shuf[$i];
    }
    return \@rands;
}

sub get_ids {
    my $file = shift;
    my @ids = ();
    open IN, $file or die "cannot open $file:$!";
    my %seen = ();
    while (my $line = <IN>) {
        chomp $line;
        next if ($seen{$line});
        push @ids, $line;
        $seen{$line}++;
    }
    return \@ids;
}

sub get_counts {
    my $ra_ids = shift;
    my $rh_go = shift;
    my %counts = ();

    foreach my $id (@{$ra_ids}) {
        next unless ($rh_go->{$id});
        my @go_ids = keys %{$rh_go->{$id}};
        foreach my $go_id (@go_ids) {
            $counts{$go_id}++;
        }
    }       
    return \%counts;
}

sub get_gohash {
    my $file = shift;
    my %go = ();

    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        chomp $line;
        my @f = split /,/, $line;
        $go{$f[0]}->{$f[1]}++;
    }
    return \%go;
}

