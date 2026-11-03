#!/usr/bin/perl
# Supervises one Claude run for claude-delegate.sh, which execs into this script so that signals sent to the wrapper
# arrive here.
#
# usage: claude-delegate-supervisor.pl <timeout seconds> <grace seconds> <temp dir> <command> [args...]
#
# Runs the command as the leader of its own process group, with <temp dir>/brief on stdin and <temp dir>/result as
# stdout. On timeout or on HUP, INT, or TERM it stops the whole group: TERM, then KILL after the grace period. After
# any ending it sends KILL to the group, so no tool the run started outlives it. The child is reaped only after the
# last signal: until then its PID, and so its process group ID, stays reserved, so no signal can reach an unrelated
# process. Exit status and output follow claude-delegate.sh's usage text; the temp dir is removed before exiting.

use strict;
use warnings;
use File::Path qw(remove_tree);
use POSIX ();

my ($timeout, $grace, $temp_dir, @command) = @ARGV;
die "claude-delegate: supervisor needs a timeout, grace, temp dir, and command\n" unless @command;

my ($child_done, $timed_out, $cancelled) = (0, 0, 0);
$SIG{CHLD} = sub { $child_done = 1 };
$SIG{ALRM} = sub { $timed_out = 1 };
$SIG{HUP} = sub { $cancelled ||= 129 };
$SIG{INT} = sub { $cancelled ||= 130 };
$SIG{TERM} = sub { $cancelled ||= 143 };

my $pid = fork();
die "claude-delegate: fork failed: $!\n" unless defined $pid;
if ($pid == 0) {
  $SIG{$_} = 'DEFAULT' for qw(CHLD ALRM HUP INT TERM);
  setpgrp(0, 0) or die "claude-delegate: setpgrp failed: $!\n";
  open(STDIN, '<', "$temp_dir/brief") or die "claude-delegate: cannot read brief: $!\n";
  open(STDOUT, '>', "$temp_dir/result") or die "claude-delegate: cannot write result: $!\n";
  exec { $command[0] } @command or die "claude-delegate: cannot run $command[0]: $!\n";
}
# Also set the group from the parent, so it exists before any signal below, however the two processes are scheduled.
POSIX::setpgid($pid, $pid);

sub signal_run {
  my ($signal) = @_;
  kill $signal, -$pid;
  kill $signal, $pid;
}

alarm $timeout;
sleep 1 until $child_done || $timed_out || $cancelled;
alarm 0;

if (!$child_done) {
  signal_run('TERM');
  for (1 .. $grace) {
    last if $child_done;
    sleep 1;
  }
}
signal_run('KILL');
waitpid($pid, 0);
my $wait_status = $?;

my $result = '';
if (open(my $result_file, '<', "$temp_dir/result")) {
  local $/;
  $result = <$result_file> // '';
  close($result_file);
}
remove_tree($temp_dir);

sub fail {
  my ($code, $message) = @_;
  print STDERR $result;
  print STDERR "claude-delegate: $message\n";
  exit $code;
}

fail($cancelled, 'cancelled') if $cancelled;
fail(124, "timed out after ${timeout}s") if $timed_out;
if ($wait_status != 0) {
  my $code = ($wait_status & 127) ? 128 + ($wait_status & 127) : $wait_status >> 8;
  fail($code, "claude exited with status $code");
}
if ($result !~ /\S/) {
  print STDERR "claude-delegate: claude returned an empty result\n";
  exit 4;
}
print STDOUT $result;
exit 0;
