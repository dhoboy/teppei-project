use strict;
use warnings;
use List::Util qw(
  reduce any all none notall first
  max maxstr min minstr product sum sum0
  pairs unpairs pairkeys pairvalues pairfirst pairgrep pairmap
  shuffle uniq uniqnum uniqstr
);

my $data_dir = "/Users/daniel/Code/teppei-project/data";
my $str_to_match = "参加";

open (my $output_fh, ">", "/Users/daniel/Code/teppei-project/results/results.csv");
print $output_fh "filename,number of times 参加 appears in the file\n";

# read through all the data files, process for appearances of $str_to_match
opendir(my $dh, $data_dir) or die ("Cannot open data directory");

while (my $file = readdir($dh)) {
  if ($file eq "." || $file eq ".."){ next; } # skip the . and .. files
  open(my $fh, "<", "$data_dir/$file") or die("Cannot open $file");

  # @ is arrays, $ is scalars, % is hashmaps
  my @matches_for_file = ();

  # loop through the file line by line: $_ is one line at a time
  while (<$fh>) {
    if ($_ =~ m/\Q$str_to_match/) {
      # counts the number of matches of the str_to_match on this line
      # scalar @line_match_count gets the length of the array of matches; this
      # accounts for more than one occurance of the $str_to_match on a single line
      my @line_match_count = $_ =~ m/\Q$str_to_match/g;
      push (@matches_for_file, scalar @line_match_count);
    }
  }

  my $matches_for_file_total = sum0 @matches_for_file;
  # print "$file: $matches_for_file_total\n";
  print $output_fh "$file,$matches_for_file_total\n";

  close($fh);
}
closedir($dh);
close($output_fh);



