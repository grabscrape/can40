#!/usr/bin/perl

use v5.10;
use Data::Dumper;
use File::Fetch;
use JSON;
use strict;

my $const='1789964';
my $profile_root = 'http://members.mps.ca/Sys/PublicProfile/';
my $cached_dir = './Cached/';

my $file = $ARGV[0] || 'fetched.json';
my $parsed = get_json( $file );

say "Parsed2";
my $info =  $parsed->{JsonStructure}->{members}->[0];
say scalar @$info;#,  ':', Dumper $info->[0];
my $index = $parsed->{JsonStructure}->{members}->[1];
say scalar @$index;#, ':', Dumper $index->[0];

for( my $i=0; $i < scalar @$info;  $i++ ) {
    say sprintf( '%3d', $i), ':', 
#        'c1:',$info->[$i]->{c1}->[0]->{sft}, ' - ',
#        'c2:',$info->[$i]->{c2}->[0]->{fft}, ' - ',
#        'c3:',$info->[$i]->{c3}->[0]->{sft}, ' - ',
#        'c3:',$info->[$i]->{c3}->[0]->{v}, ' - ',
#        'c2:',$info->[$i]->{c2}->[0]->{v}, ' - ',
#        'c1:',
        $info->[$i]->{c1}->[0]->{v},
        "::\t", $index->[$i];

        my $cache_file = "${cached_dir}$index->[$i]".'.html';
        my $url = $profile_root.$index->[$i].'/'.$const;

        print $cache_file, ': ', $url, ' : ';
        if( -f $cache_file ) {
            say 'Exists';
        } else {
            say 'Need to grab';
            get_content( $url, $cache_file );
        }
#last;
}
exit 0;



sub get_content {
    my $uri = shift;
    my $filename = shift;
    my $ff = File::Fetch->new( uri => $uri );
    my $where = $ff->fetch();# to => $cached_dir );
    say 'Where:  ', $where;
    rename $where, $filename;
    #return $ff->file;
}

sub get_json {
    my $fn = shift;
    my $body;

    open FD, $fn or die "Error: $!";
    $body .= $_ for <FD>;
    close FD;

    $body =~ s/^while\(1\);\s//;
    $body =~ s/"//g;
    $body =~ s/\\u0027/'/g;
    $body =~ s/\\u003c/</g;
    $body =~ s/\\u003e/>/g;

#say $body;
#exit 0;
    my $flags = {allow_barekey => 1, allow_singlequote => 1};
    my $parsed = from_json( $body, $flags );
    return $parsed;

}

