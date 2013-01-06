#!/usr/local/bin perl -w

use strict;
use Expect;
use String::Random qw(random_regex);
use Getopt::Long;

my $kill;
my $spawn;
my $printer;
my $current_password;
my $new_password;
my $options = GetOptions("current_password=s" => \$current_password);

sub random_digits {
    random_regex '\d\d\d\d\d\d\d\d\d\d'; # 10 digit numeric string
}

my $send_current_password = sub {
    my $exp = shift;
    $exp->send($current_password . "\n");
    exp_continue;
};

sub change_password {
    my $new_password = shift;

    my $send_new_password = sub {
        my $exp = shift;
        $exp->send($new_password . "\n");
        exp_continue;
    };

    my $exp = Expect->spawn("passwd") or die "Cannot spawn passwd: $!\n";
    $exp->expect(undef,
                 [ qr/Old password:/        => $send_current_password ],
                 [ qr/New password:/        => $send_new_password ],
                 [ qr/Retype new password:/ => $send_new_password ]);

    $exp->soft_close();
    if ($exp->exitstatus() == 0) {
        print "New password set to $new_password\n";
        1;
    } else {
        print "Cannot change password\n";
        0;
    }
}

my $random_password = random_digits;
change_password $random_password;
open (FILE, '>>passwds');
print FILE "$random_password\n";
close (FILE);
