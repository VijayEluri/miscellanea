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
my $options = GetOptions("kill"               => \$kill,
                         "current_password=s" => \$current_password,
                         "new_password=s"     => \$new_password,
                         "printer=s"          => \$printer,
                         "spawn"              => \$spawn);
sub random_digits {
 random_regex '\d\d\d\d\d\d\d\d\d\d'; # 10 digit numeric string
}

sub lp {
  my $string = shift;
  print "Printing data to printer $printer\n";
  return 0 unless $printer;
  return 1 if system("echo $string | lp -d $printer -") == 0;
  return 0;
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

sub toggle_network_interface {
  my $inteface = shift;
  my $command  = shift;

  my $exp = Expect->spawn("sudo ifconfig $inteface $command") or die "Cannot spawn $command: $!\n";
  $exp->expect(undef, [ qr/Password:/ => $send_current_password ]);
  $exp->soft_close();
  if ($exp->exitstatus() == 0) {
    print "Successfully ran the command 'sudo ifconfig $inteface $command'\n";
    1;
  } else {
    print "Failed to ran the command 'sudo ifconfig $inteface $command'\n";
    0;
  }
}

if ($kill) {
  my $random_password = random_digits;
  lp $random_password;
  change_password $random_password;
} elsif ($spawn) {
  change_password $new_password;
}
