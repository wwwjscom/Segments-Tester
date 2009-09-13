#!/usr/local/bin/perl -w

=head1 NAME

rank.pl - Calculate Spearman's Correlation on two ranked lists output by count.pl or statistic.pl

=head1 SYNOPSIS

Program to calculate the rank correlation coefficient between the rankings
generated by two different statistical measures on the same
bigram-frequency (as output by count.pl).

=head1 DESCRIPTION

=head2 1. Introduction

This is a program that is meant to be used to compare two different  
statistical measures of association. Given the same set of n-grams ranked  
in two different ways by two different statistical measures, this program  
computes Spearman's rank correlation coefficient between the two rankings.  

=head3 1.1. Spearman's rank correlation coefficient: 

Assume we have n n-grams ranked in two ways such that each ngram has
two ranks created by the two measures. Let Di represent the difference
between the two ranks for ngram i. Then Spearman's rank correlation
coefficient r is given by the following formula:

             i=n
         6 X SUM(Di^2)
             i=1
 r = 1 - ------------
          n(n^2 - 1)


That is, find the sum of the squares of the differences Di between
ranks for each ngram i, and then multiply by 6 and divide by
n(n^2-1). Note that when for every ngram, the two ranks of are always
the same, that is the two rankings perfectly match, then Di is always
0, and so r = 1. It can be shown that when two rankings are exactly
opposite to each other, that is every ngram has ranks a and n-a in the
two rankings, then r = -1. 

=head3 1.2. Typical Way to Run rank.pl:

Assume that test.cnt is a list of n-grams with their frequencies as
output by program count.pl. Assume that we wish to test the
dis/similarity of the statistical measures 'dice' and 'x2' with
respect to the n-grams contained in test.cnt. To do so, we must first
rank the n-grams using these two statistical measures using program
statistic.pl. 

 perl statistic.pl dice test.dice test.cnt
 perl statistic.pl x2 test.x2 test.cnt

Having obtained two different rankings of the n-grams in test.cnt in
files test.dice and test.x2, we can now compute the Spearman's rank
correlation coefficient using these two rankings like so: 

 perl rank.pl test.dice test.x2. 

This will output a floating point number between -1 and 1. A return of
'1' indicates a perfect match in rankings, '-1' a completely reversed
ranking and '0' a pair of rankings that are completely unrelated to
each other. Numbers that lie between these numbers indicate various
degrees of relatedness / un-relatedness / reverse-relatedness.

=head3 1.3. Re-Ranking the Ngrams:

Recall that program statistic.pl ranks n-grams in such a way that the
fact that an ngram has a rank 'r' implies that there are 'r-1'
distinct scores greater than the score of this ngram. Thus say if 'k'
n-grams are tied at a score with rank 'a', then the next highest
scoring n-grams is given a rank 'a+1' instead of 'a+k+1'. 

For example, observe the following file output by statistic.pl: 

 11
 of<>text<>1 1.0000 2 2 2
 and<>a<>1 1.0000 1 1 1
 a<>third<>1 1.0000 1 1 1
 text<>second<>1 1.0000 1 1 1
 line<>of<>2 0.8000 2 3 2
 third<>line<>3 0.5000 1 1 3
 line<>and<>3 0.5000 1 3 1
 second<>line<>3 0.5000 1 1 3
 first<>line<>3 0.5000 1 1 3

Observe that although 4 bigrams have a rank of 1, the next highest
scoring bigram is not ranked 5, but instead 2. 

Spearman's rank correlation coefficient requires the more conventional
kind of ranking. Thus the above file is first "re-ranked" to the
following: 

 11
 of<>text<>1 1.0000 2 2 2
 and<>a<>1 1.0000 1 1 1
 a<>third<>1 1.0000 1 1 1
 text<>second<>1 1.0000 1 1 1
 line<>of<>5 0.8000 2 3 2
 third<>line<>6 0.5000 1 1 3
 line<>and<>6 0.5000 1 3 1
 second<>line<>6 0.5000 1 1 3
 first<>line<>6 0.5000 1 1 3

And then these rankings are used to compute the correlation
coefficient. 

=head3 1.4. Dealing with Dissimilar Lists of N-grams:

The two input files to rank.pl may not have the same set of n-grams. In
particular, if one or both of the files generated using statistic.pl
has been generated using a frequency, rank or score cut-off, then it
is likely that the two files will have different sets of n-grams. In
such a situation, n-grams that do not occur in both files are removed,
the n-grams that remain are re-ranked and then the correlation
coefficient is computed. 

For example assume the following two files output by statistic.pl
using two fictitious statistical measures from a fictitious file
output by program count.pl.

The first file: 

 first<>bigram<>1 4.000 1 1 
 second<>bigram<>2 3.000 2 2 
 extra<>bigram1<>3 2.000 3 3 
 third<>bigram<>4 1.000 4 4

The second file:

 second<>bigram<>1 4.000 2 2 
 extra<>bigram2<>2 3.000 4 4 
 first<>bigram<>3 2.000 1 1 
 third<>bigram<>4 1.000 3 3 

Observe that the bigrams extra<>bigram1<> in the first file and
extra<>bigram2<> in the second file are not present in both
files. After removing these bigrams and re-ranking the rest, we get the
following files: 

The modified first file: 

 first<>bigram<>1 4.000 1 1 
 second<>bigram<>2 3.000 2 2 
 third<>bigram<>3 1.000 4 4

The modified second file:

 second<>bigram<>1 4.000 2 2 
 first<>bigram<>2 2.000 1 1 
 third<>bigram<>3 1.000 3 3 

Since each ngram belongs to both files, the correlation coefficient
may be computed on both files. 

=head3 1.5. Example Shell Script rank-script.sh:

We provide c-shell script rank-script.sh that takes a bigram count
file and the names of two libraries and then computes the Spearman's
rank correlation coefficient by making use successively of programs
statistic.pl and rank.pl.

Run this script like so: rank-script.sh <lib1> <lib2> <file>

    where <lib1> is the first library, say dice
          <lib2> is the second library, say x2
	  <file> is the file of ngrams and their frequencies produced
		 by program count.pl.

For example, if test.cnt contains bigrams and their frequencies, we
can run it like so to compute the rank correlation coefficient between
dice and x2: 

    csh rank-script.sh dice x2 test.cnt.

This runs the following commands in succession: 

 perl statistic.pl dice out1 test.cnt
 perl statistic.pl x2 out2 test.cnt
 perl rank.pl out1 out2

The intermediate files out1 and out2 are later destroyed. 

Note that since no command line options are utilized in the running of
program statistic.pl here, this script only works for bigrams and
enforces no cut-offs. However the script is simple enough to be
manually modified to the user's requirements.

=head1 AUTHORS

 Ted Pedersen, tpederse@umn.edu
 Satanjeev Banerjee, bane0025@d.umn.edu

This work has been partially supported by a National Science Foundation
Faculty Early CAREER Development award (\#0092784) and by a Grant-in-Aid  
of Research, Artistry and Scholarship from the Office of the Vice  
President for Research and the Dean of the Graduate School of the  
University of Minnesota.

=head1 COPYRIGHT

Copyright (C) 2000-2003, Ted Pedersen and Satanjeev Banerjee

This suite of programs is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your option) 
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with 
this program; if not, write to the Free Software Foundation, Inc., 59 Temple 
Place - Suite 330, Boston, MA  02111-1307, USA.

Note: The text of the GNU General Public License is provided in the file 
GPL.txt that you should have received with this distribution. 

=cut

#
#-----------------------------------------------------------------------------
#                                 Start of Program!
#-----------------------------------------------------------------------------

# we have to use commandline options, so use the necessary package!
use Getopt::Long;

# first check if no commandline options have been provided... in which case
# print out the usage notes!
if ( $#ARGV == -1 )
{
    minimalUsageNotes();
    askHelp();
    exit;
}

# now get the options!
GetOptions("version", "help", "precision=i");

# if help has been requested, print out help and exit
if (defined $opt_help)
{
    $opt_help = 1;
    showHelp();
    exit;
}

# if version has been requested, print out the version number and exit
if (defined $opt_version)
{
    $opt_version = 1;
    showVersion();
    exit;
}

# get the first file.
$firstFile = shift;
open(SRC, $firstFile) || die("Couldn't open $firstFile\n");
while(<SRC>)
{
    next unless(/^((\S+<>)+)(\d+)\s/);
    $list1{$1} = $3;
}
close(SRC);

# get from the second file only those ngrams that are in the first
# file. Also continuously "rerank".
$secondFile = shift;
if (!defined $secondFile) 
{ 
    print STDERR "Second file not provided.\n"; 
    askHelp(); 
    exit; 
}

open(SRC, $secondFile) || die("Couldn't open $secondFile\n");
$lastRankSeen = 0;
$lastRankUsed = 0;
$tiesAtLastRank = 0;
while(<SRC>)
{
    next unless(/^((\S+<>)+)(\d+)\s/);
    my $ngram = $1;
    my $rank = $3;

    # ignore ngrams not on first list
    next unless(defined $list1{$ngram});

    # save ngram in second list, but after adjusting rank
    if ($rank == $lastRankSeen)
    {
	$list2{$ngram} = $lastRankUsed;
	$tiesAtLastRank++;
    }
    else
    {
	$list2{$ngram} = $lastRankUsed + $tiesAtLastRank + 1;
	$lastRankUsed  = $lastRankUsed + $tiesAtLastRank + 1;
	$lastRankSeen = $rank;
	$tiesAtLastRank = 0;
    }
}
close(SRC);

# now remove those ngrams in list1 that dont exist in list2, and rerank
$lastRankSeen = 0;
$lastRankUsed = 0;
$tiesAtLastRank = 0;
foreach (sort {$list1{$a} <=> $list1{$b}} keys %list1)
{
    # remove ngrams not on second list
    next unless (defined $list2{$_});

    # Adjust rank
    if ($list1{$_} == $lastRankSeen)
    {
	$adjustedList1{$_} = $lastRankUsed;
	$tiesAtLastRank++;
    }
    else
    {
	$adjustedList1{$_} = $lastRankUsed + $tiesAtLastRank + 1;
	$lastRankUsed  = $lastRankUsed + $tiesAtLastRank + 1;
	$lastRankSeen = $list1{$_};
	$tiesAtLastRank = 0;
    }
}

%list1 = %adjustedList1;

# compute the coeff and count the number of bigrams being used
$bigramsUsed = 0;
$coeff = 0;
foreach (sort {$list1{$b} <=> $list1{$a}} keys %list1)
{
    $bigramsUsed++;
    $diff = $list1{$_} - $list2{$_};
    $coeff += $diff * $diff;
}

if ($bigramsUsed == 0)
{
    print STDERR "No bigrams to calculate rank correlation coefficient for.\n";
    exit;
}

$coeff *= 6;
$coeff /= $bigramsUsed * ( $bigramsUsed * $bigramsUsed - 1 );
$coeff = 1 - $coeff;

$precision = (defined $opt_precision) ? $opt_precision : 4;
$floatFormat = "%.${precision}f";
printf("Rank correlation coefficient = $floatFormat\n", $coeff);
    
# function to output a minimal usage note when the user has not provided any
# commandline options
sub minimalUsageNotes
{
    print "Usage: rank.pl [OPTIONS] SOURCE_FILE1 SOURCE_FILE2\n";
}

# function to output help messages for this program
sub showHelp
{
    print "Usage: rank.pl [OPTIONS] SOURCE_FILE1 SOURCE_FILE2\n\n";

    print "To compute the Spearman rank correlation coefficient between two lists\n";
    print "of ngrams produced by program statistic.pl using two (probably different)\n";
    print "statistical measures. SOURCE_FILE1 and SOURCE_FILE2 should contain the two\n";
    print "lists respectively. Ngrams occurring in both source files are chosen,\n";
    print "their ranks are adjusted and then these ranks are used to compute the\n";
    print "correlation coefficient.\n\n";

    print "OPTIONS:\n\n";

    print "   --precision N   Rounds coefficient to N places of decimal. N = 4 by\n";
    print "                   default.\n\n";

    print "   --version       Prints the version number.\n\n";

    print "   --help          Prints this help message.\n\n";

}


# function to show the version number
sub showVersion
{
    print "rank.pl         -       version 0.01\n";
    print "Copyright (C) 2000-2003, Ted Pedersen & Satanjeev Banerjee\n";
}

# function to output "ask for help" message when the user's goofed up!
sub askHelp
{
    print STDERR "Type rank.pl --help for help.\n";
}