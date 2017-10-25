#!/usr/bin/perl
use strict;
use warnings;
use utf8;

my $icon;
my $acpi;
my $status;
my $percent;
my $ac_adapt;
my $full_text;
my $short_text;
my $bat_number = $ENV{BLOCK_INSTANCE} || 0;

# read the first line of the "acpi" command output
open (ACPI, "acpi -b | grep 'Battery $bat_number' |") or die;
$acpi = <ACPI>;
close(ACPI);

# fail on unexpected output
if ($acpi !~ /: (\w+), (\d+)%/) {
    die "$acpi\n";
}

$status = $1;
$percent = $2;
$full_text = "$percent%";

if ($status eq 'Discharging') {
    $icon = "";
} else {
    $icon = "";
}

if ("$percent" eq "100%" ) {
    print "$icon$full_text\n";
    print "$icon$full_text\n";
} else {
# print text
    print "$icon$full_text\n";
    print "$icon$full_text\n";
}

# consider color and urgent flag only on discharge
if ($status eq 'Discharging') {

    if ($percent < 20) {
        print "#FF0000\n";
    } elsif ($percent < 40) {
        print "#FFAE00\n";
    } elsif ($percent < 60) {
        print "#FFF600\n";
    } elsif ($percent < 85) {
        print "#A8FF00\n";
    }

    if ($percent < 5) {
        exit(33);
    }
}

exit(0);
