*******************************************************************************

		     README.txt FOR Testing sort-bigrams.pl

                               Version 0.02
                         Copyright (C) 2002-2004
                       Ted Pedersen, tpederse@umn.edu
                    Amruta Purandare pura0010@d.umn.edu
                       University of Minnesota, Duluth

		   http://www.d.umn.edu/~tpederse/nsp.html

*******************************************************************************


Testing for sort-bigrams.pl
---------------------------

AMRUTA PURANDARE
pura0010@d.umn.edu
03/04/2004

1. Introduction: 
----------------

This program is a component of the N-gram Statistics Package that sorts a given
bigram file in the descending order of the bigram scores.
The scripts and files provided here could be used to test the correct 
behaviour of the program and backward compatibility. 

2. Tests:
----------

2.1 Normal conditions:
----------------------

Tests written in testA*.sh test sort-bigrams.pl under normal conditions.
Run normal-op.sh to run all test cases testA*.sh 

Test A1:        Tests when the bigram file shows counts

Test A2:        Tests when the input bigram file is already sorted

Test A3:        Tests when the bigram file shows scores

Test A4:        Tests when the tokens include embedded spaces and punctuations

Test A5:        Tests when the bigram file is created by combine-counts.pl

Test A6:	Tests when --frequency is specified

Test A7:	Tests when --remove option is specified

2.2 Error conditions:
----------------------

Tests written in testB*.sh test sort-bigrams.pl under error conditions.
Run error-op.sh to run all test cases testB*.sh

Test B1:	Tests when the bigram file is incorrectly formatted

3. Conclusions:
---------------

We have tested program sort-bigrams.pl enough to conclude that it runs 
correctly. We have also provided the test scripts so that future versions of 
sort-bigrams.pl can be compared to the current version against these scripts.

