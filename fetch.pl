#!/usr/bin/perl

use v5.10;
use LWP::UserAgent;
use Data::Dumper;
use JSON;
use utf8;
use strict;

 
my $ua = LWP::UserAgent->new;
 
#my $server_endpoint = "http://members.mps.ca/";
my $server_endpoint = 'http://members.mps.ca/Sys/MemberDirectory/LoadMembers';
 
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_endpoint);
#$req->header('content-type' => 'application/json');
#$req->header('x-auth-token' => 'kfksj48sdfj4jd9d');

#POST /Sys/MemberDirectory/LoadMembers HTTP/1.1
$req->header('Host' => 'members.mps.ca');
$req->header('Connection' => 'keep-alive');
##Content-Length: 14
$req->header('Accept' => '*/*');
##Origin: http://members.mps.ca
$req->header('X-Requested-With' => 'XMLHttpRequest' );
$req->header('User-Agent'=> 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36');
$req->header('Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8');
##Referer: http://members.mps.ca/
$req->header('Accept-Encoding'=>'gzip, deflate');
$req->header('Accept-Language' => 'ru,en-US;q=0.8,en;q=0.6');

 
# add POST data to HTTP request body
my $post_data = 'formId=1789964'; #, "address": "NY" }';
$req->content($post_data);
 
my $resp = $ua->request($req);

my $message;

if ($resp->is_success) {
    #my $message = $resp->decoded_content;
    $message = $resp->decoded_content;
    $message =~ s/^while\(1\);\s//;
    print "$message";
}
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print "HTTP POST error message: ", $resp->message, "\n";
    exit 1;
}

exit 0;
my $perl_hash_or_arrayref  = decode_json $message;
my $structure  = decode_json $message->{JsonStructure};

#say Dumper $structure;
