package Foo;
use strict;
use warnings;

{
    my $instance;
    sub singleton {
        $instance = Foo->new;
        {
            no strict 'refs';
            no warnings 'redefine';
            *{__PACKAGE__ . '::singleton'} = sub { $instance };
        }
        return $instance;
    }
}

1;
