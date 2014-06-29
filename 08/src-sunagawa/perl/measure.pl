#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use 5.008;
use autodie;
use Data::Dumper;
use DBI;

use lib ('.');
use SQLExplainToMarkdown;

my $dbh = DBI->connect(
    'DBI:mysql:dbname=rakumeshi;host=localhost',
    'root',
    '',
    {
        AutoCommit => 1,
        RaiseError => 1,
    },
) or die $DBI::errstr;


$measurement->report(
    "SELECT id, password FROM user WHERE name = ? OR email = ?;",
    +["name0000010", ""], $ITER_NUM
);
