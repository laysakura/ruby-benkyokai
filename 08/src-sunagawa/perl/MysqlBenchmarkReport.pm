package MysqlBenchmarkReport;
use strict;
use warnings;
use utf8;
use Data::Dumper;
use Time::HiRes qw/gettimeofday tv_interval/;

sub new {
    my ( $class, $dbh ) = @_;
    return bless +{ dbh => $dbh, }, $class;
}

sub report {
    my $self     = shift;
    my $stmt     = shift;
    my $params   = shift;
    my $ITER_NUM = shift || 10000;

    #計測開始
    my $start_sec      = [gettimeofday];
    my $execute_result = $self->_execute_stmt( $stmt, $params, $ITER_NUM );
    my $response_sec   = tv_interval($start_sec);

    $execute_result->{response_sec} = $response_sec;
    $execute_result->{qps}          = $ITER_NUM / $response_sec;

    my $explain_result = $self->_execute_explain( $stmt, $params );

    $self->_print_execute($execute_result);
    $self->_print_explain($explain_result);
    return $self->_get_first_column_values( $stmt, $params );
}

sub _print_execute {
    my ( $self, $execute_result ) = @_;

    #markdown形式
    print <<"EOF";

###  SQL

```sql
    $execute_result->{statement}
```

### Summary

| name          | value |
| ------------: | :---- |
| Hit rows      | $execute_result->{rows} |
| Iterate n     | $execute_result->{iter_num} |
| Response time | $execute_result->{response_sec} sec. |
| QPS           | $execute_result->{qps} query/sec. |

EOF
}

sub _print_explain {
    my ( $self, $explain_result ) = @_;

    my $max_len;
    my $column_len;

    my $key_row      = '|';
    my $intermid_row = '|';
    my $value_row    = '|';

    my @keys =
      qw/id select_type table type possible_keys key key_len ref rows Extra/;
    foreach my $key (@keys) {
        my $value = $explain_result->{$key} || 'undef';

        my $key_len   = length($key);
        my $value_len = length($value);

       #　max_lenに足りないものをスペースで埋める。$column_len
        if ( $key_len > $value_len ) {
            $key .= ' ' if ( $key_len < 3 );
            $key_len = 3 if ( $key_len < 3 );

            my $diff_len = $key_len - $value_len;
            $key_row      .= " $key |";
            $intermid_row .= ' ' . '-' x $key_len . ' |';
            $value_row    .= " $value" . ' ' x $diff_len . ' |';
        }
        else {
            $value_len = 3 if ( $value_len < 3 );
            my $diff_len = $value_len - $key_len;
            $key_row      .= " $key" . ' ' x $diff_len . ' |';
            $intermid_row .= ' ' . '-' x $value_len . ' |';
            $value_row    .= " $value" . ' |';
        }
    }
    print "### Explain\n";
    print "$key_row\n$intermid_row\n$value_row\n";
}

sub _execute_stmt {
    my ( $self, $stmt, $params, $ITER_NUM ) = @_;
    foreach ( 1 .. $ITER_NUM ) {
        my $sth = $self->{dbh}->prepare($stmt);
        $sth->execute(@$params);
        return +{
            statement => $sth->{Statement},
            rows      => $sth->rows,
            iter_num  => $ITER_NUM,
          }
          if $_ == $ITER_NUM;
    }
}

sub _execute_explain {
    my ( $self, $stmt, $params ) = @_;
    my $explain_stmt = "explain $stmt";
    my $sth          = $self->{dbh}->prepare($explain_stmt);
    $sth->execute(@$params);
    return $sth->fetchrow_hashref;
}

sub _get_first_column_values {
    my ( $self, $stmt, $params ) = @_;
    my $sth = $self->{dbh}->prepare($stmt);
    $sth->execute(@$params);

    my @values;
    while ( my $row = $sth->fetchrow_arrayref ) {
        push @values, $row->[0];
    }
    return \@values;
}

1;
