*******************************************************************************

		     README.txt FOR Testing huge-combine.pl

                               Version 0.01
                         Copyright (C) 2002-2004
                       Ted Pedersen, tpederse@umn.edu
                    Amruta Purandare pura0010@d.umn.edu
                       University of Minnesota, Duluth

		   http://www.d.umn.edu/~tpederse/nsp.html

*******************************************************************************


Testing for huge-combine.pl
------------------------------

AMRUTA PURANDARE
pura0010@d.umn.edu
03/03/2004

1. Introduction: 
----------------

This program is a component of the N-gram Statistics Package that combines
two bigram count files.
The scripts and files provided here could be used to test the correct 
behavior of the program and backward compatibility. 

2. Tests:
----------

2.1 Normal conditions:
----------------------

Tests written in testA*.sh test huge-combine.pl under normal conditions.
Run normal-op.sh to run all test cases testA*.sh 

Test A1:
Test A2:	Tests on general bigram files

Test A3:	Tests when the tokens include punctuations

Test A4:	Tests when the two count files share no bigrams

Test A5:	Tests when the two count files share all bigrams

Test A6:	Tests when tokens include embedded spaces and upper case 
		letters

Test A7:	Tests when the count files are generated with default
		token scheme from the README file contents

2.2 Error conditions:
----------------------

Tests written in testB*.sh test huge-combine.pl under error conditions.
Run error-op.sh to run all test cases testB*.sh

Test B1:	Tests when a bigram is repeated in the same file

Test B2:	Tests when a word has different marginals in the same file

3. Conclusions:
---------------

We have tested program huge-combine.pl enough to conclude that it runs 
correctly. We have also provided the test scripts so that future versions of 
huge-combine.pl can be compared to the current version against these scripts.
