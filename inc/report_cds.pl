#!/usr/bin/env perl

use strict;
use warnings;

use Mojo::DOM;
use Mojo::Util qw( slurp );

my $xml = slurp 'inc/cds.xml';
my $dom = Mojo::DOM->new($xml);
my $cds = $dom->at('cds')->children;

foreach my $cd ( $cds->each ) {
    printf "Found CD: %s - %s (%d)\n",
        $cd->find( 'title, artist, year' )->pluck('text')->each;
}

printf "There are %d CD(s) total.\n", $cds->size;
