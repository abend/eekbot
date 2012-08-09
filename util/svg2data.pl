#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use List::AllUtils qw(max min);
use FindBin qw($Bin);

#our $MAX_SIZE = 600; # mm =~ 24"
our $MAX_SIZE = 75;

my $in = shift @ARGV;
die "usage: $0 file.svg" unless $in;

my @data = get_lines($in);
@data = scale(@data);
write_class(@data);

sub get_lines {
  my $in = shift;

  open(my $inf, '<', $in) or die "can't open $in: $!";
  my $grab = 0;
  my @lines;
  for my $line (<$inf>) {
    chomp $line;
    $grab = 0 if ($grab and $line =~ /^" \/>/);
    push @lines, [split /\s+/, $line] if $grab;
    $grab = 1 if (!$grab and $line =~ /^<path/);
  }
  #say "grabbed ".scalar(@lines)." lines from $in";
  return @lines;
}

sub scale {
  my @data = @_;

  my $minx = min(map { $$_[0] } @data);
  my $miny = min(map { $$_[1] } @data);
  my $maxx = max(map { $$_[0] } @data);
  my $maxy = max(map { $$_[1] } @data);

  my $ctrx = ($minx + $maxx) / 2;
  my $ctry = ($miny + $maxy) / 2;
  my $rangex = ($maxx - $minx);
  my $rangey = ($maxy - $miny);

  my $scale = $MAX_SIZE / max($rangex, $rangey);
  #my $offsetx = $scale * $ctrx;
  #my $offsety = $scale * $ctry;

  say "data from $minx,$maxx (ctr $ctrx) $miny,$maxy (ctr $ctry)";
  say "data scaled $scale";# and offset $offsetx $offsety";

  my @newdata;
  for my $line (@data) {
    push @newdata, [($$line[0] - $ctrx) * $scale,
                    ($$line[1] - $ctry) * $scale];
  }

  my $minx2 = min(map { $$_[0] } @newdata);
  my $miny2 = min(map { $$_[1] } @newdata);
  my $maxx2 = max(map { $$_[0] } @newdata);
  my $maxy2 = max(map { $$_[1] } @newdata);
  my $ctrx2 = ($minx2 + $maxx2) / 2;
  my $ctry2 = ($miny2 + $maxy2) / 2;
  say "new data from $minx2,$maxx2 (ctr $ctrx2) $miny2,$maxy2 (ctr $ctry2)";

  return @newdata;
}

sub write_class {
  my @data = @_;

  open my $out, '>', "$Bin/../nxt/Data.java" or die "can't open data file: $!";

  write_header($out);
  write_data($out, @data);
  write_footer($out);
}

sub write_header {
  my $out = shift;

  print $out <<EOM;
public class Data {
  public static int[] data = new int[] {
EOM
}

sub write_data {
  my $out = shift;

  for my $p (@_) {
    say $out "    ", join(',', map { int($_+.5) } 1, @$p),",";
  }
}

sub write_footer {
  my $out = shift;

  print $out <<EOM;
  };
}
EOM
}
