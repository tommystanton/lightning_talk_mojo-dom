#!/usr/bin/env perl

use strict;
use warnings;

use Mojo::DOM;
use Mojo::Util qw( slurp spurt );

my $xml = slurp 'inc/foobar_channel.xml';
my $dom = Mojo::DOM->new($xml);

diag_destinations($dom);
prompt_for_enter();

toggle_dest( { dest => 'to_quux', toggle => 'off', dom => $dom } );
diag_destinations($dom);
prompt_for_enter();

toggle_dest( { dest => 'to_baz', toggle => 'off', dom => $dom } );
diag_destinations($dom);
prompt_for_enter();

toggle_dest( { dest => 'to_quux', toggle => 'on', dom => $dom } );
diag_destinations($dom);

prompt_for_enter();

spurt $dom, 'inc/foobar_channel-2.xml';

system('vimdiff -u NONE -Ro inc/foobar_channel.xml inc/foobar_channel-2.xml');

sub diag_destinations {
    my ($dom) = @_;

    my $destinations = $dom->at('destinationConnectors')->children;

    foreach my $dest ( $destinations->each ) {
        printf "Destination: %s\n", $dest->at('connector > name')->text;
        printf "...is enabled? %s\n",
            $dest->at('enabled')->text eq 'true' ? 'Yes' : 'No';
    }

    print "\n";
}

sub toggle_dest {
    my ($args) = @_;

    my $dom       = $args->{dom};
    my $dest_name = $args->{dest};
    my $toggle    = $args->{toggle};

    my $dest_dom =
        $dom->find( 'destinationConnectors > connector > name' )
            ->first( sub { $_->text eq $dest_name } )
            ->parent;

    $dest_dom->at('enabled')->replace_content(
        $toggle eq 'on' ? 'true' : 'false'
    );
}

sub prompt_for_enter {
    print "Press enter to continue...\n";
    <STDIN>;
}
