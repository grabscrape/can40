use v5.10;
use Data::Dumper;
use Data::Printer;

## http://habrahabr.ru/post/227493/
use Mojo::DOM;

my $url = 'http://members.mps.ca/Sys/PublicProfile/%s/1789964';

my $output = `find ./Cached -name \*html -type f | grep  -v x26748378 `;

my @fields = (
        'First name',
        'Last name',
        'Organization',
        'Work Phone',
        'Fax Number',
        'Mobile Phone',
        'E-Mail',
        'Website',
        'Address',
        'City/Town',
        'Province',
        'Postal Code',
        'URL'
);

my @data = ();
foreach my $line (split /\n/, $output ) {
    #say $line;
    if( $line =~ m/\D(\d+).html/ ) {
        #say $1; 
        my $s = parse( $line, {num=>$1} );
        $s->{URL} = sprintf $url, $1;
        #say Dumper $s;
        push @data, $s;
    }
    #say '-'x40;
    #say;
}

#say Dumper \@data;

open CSV, ">can40.csv";
say CSV join '|', @fields;
foreach my $d (@data) {
    say CSV join '|', map {
        $d->{$_}
    } @fields;
}
close CSV;


my $o=`csv2excel.py --sep '|' --title --output ./can40.xls ./can40.csv`;
say "Py output: $o" if $o;


### Subs
sub parse {
    my $file = shift;
    my $data = shift;

    ##grep -A 5   -P '\s+<div class="fieldLabel' Cached/*html  | less -SX

    my $p1 = `cat $file | grep -A 6   -P '\\s+<div class="fieldLabel'`;

    my (@parts) = split /^--$/m, $p1;
    #say Dumper \@parts;

    my %t = ();
    foreach my $p ( @parts ) {
        my( $label, $body) = eparse($p);
        $t{$label} = $body if $label;
    }
    return \%t; 
}

sub eparse {
    my $s = shift;

        #'E-Mail (internal use only)',

    my $label;
    if( $s =~ m/"fieldLabel">\r\n\s+<span.*>(.*)<\/span>/m ) {
        $label = $1;
        $label = 'E-Mail' if $label eq 'E-Mail (internal use only)';
    }
    
    return undef unless grep $label eq $_, @fields;
  
    my  $body; 
    if( $s =~ m/"fieldBody">\r\n\s+.*<span.*?>(.*)<\/span>/m ) {
        $body = $1;
        if( ($label eq 'E-Mail' or $label eq 'Website' ) 
            and $body =~ m/href="(mailto:)?(\S+)"/ ) {
            $body = $2;
        }
    }

    #say "$label:\t\t$body";
    return $label, $body; 

}

exit 0;

__END__

      1 Label: PAM Registration #
      1 Label: University
      2 Label: Highest Degree obtained
      3 Label: Are you registered with PAM?
      3 Label: PAM Category
     39 Label: Photo
     57 Label: Wait Times
     71 Label: Statement of Services
     86 Label: Assessments
    101 Label: Therapy
    106 Label: Spoken Languages
    108 Label: Populations
    111 Label: Area of Expertise


     57 Label: Organization
      1 Label: E-Mail (internal use only)
     38 Label: Mobile Phone
     40 Label: Website
     82 Label: Fax Number
     84 Label: E-Mail
    121 Label: Work Phone
    123 Label: Address
    124 Label: Postal Code
    125 Label: City/Town
    125 Label: Province
    127 Label: First name
    127 Label: Last name
