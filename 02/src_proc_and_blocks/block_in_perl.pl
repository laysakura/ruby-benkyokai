use strict;
use warnings;

my $s = sub {
    my $x = shift;
    $x + 10;
};
print $s->(100);
