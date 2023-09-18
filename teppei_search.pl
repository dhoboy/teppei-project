use strict;
use warnings;
use List::Util qw(
  reduce any all none notall first
  max maxstr min minstr product sum sum0
  pairs unpairs pairkeys pairvalues pairfirst pairgrep pairmap
  shuffle uniq uniqnum uniqstr
);

my $data_dir = "/Users/daniel/Code/teppei-project/data";
my $str_to_match = $ARGV[0];

# process data and build results here
my @results = ();

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
  push(@results, { "filename" => $file, "freq" => $matches_for_file_total });

  close($fh);
}
closedir($dh);

# open file for printing results
open (my $output_fh, ">", "/Users/daniel/Code/teppei-project/results/$str_to_match-frequency.csv");

# print csv headers
print $output_fh "filename,number of times $str_to_match appears in the file\n";

# sort and print results to file
my @sorted_results = sort { $b->{"freq"} <=> $a->{"freq"} } @results;
for my $item (@sorted_results) {
  print $output_fh "$item->{filename},$item->{freq}\n";
}

close($output_fh);



