*******************************************************************************

		     README.txt FOR Testing huge-count.pl

                               Version 0.02
                         Copyright (C) 2002-2004
                       Ted Pedersen, tpederse@umn.edu
                    Amruta Purandare pura0010@d.umn.edu
                       University of Minnesota, Duluth

		   http://www.d.umn.edu/~tpederse/nsp.html

*******************************************************************************


Testing for huge-count.pl
---------------------------

AMRUTA PURANDARE
pura0010@d.umn.edu
03/04/2004

1. Introduction: 
----------------

This program is a component of the N-gram Statistics Package that efficiently
runs count.pl on a large data. 
The scripts and files provided here could be used to test the correct 
behaviour of the program and backward compatibility. 

2. Tests:
----------

2.1 Normal conditions:
----------------------

Tests written in testA*.sh test huge-count.pl under normal conditions.
Run normal-op.sh to run all test cases testA*.sh 

Test A1:	Tests huge-count when input is a single data file

Test A2:	Tests huge-count when input is a directory

Test A3:	Tests huge-count when input is a list of plain files

Test A4:	Tests huge-count's --frequency option

Test A5:	Runs huge-count with --token, --nontoken, --newLine, --window 
		options together

Test A6:	Tests huge-count's --remove option

Test A7:	Runs A1, A2, A3 without --newLine

Test A8:	Compares A1, A2, A3 's outputs against normal count


2.2 Error conditions:
----------------------

Tests written in testB*.sh test huge-count.pl under error conditions.
Run error-op.sh to run all test cases testB*.sh

Test B1:	Tests huge-count when input contains more than one directory

Test B2:	Tests huge-count when a single plain file is provided without
		--split


3. Conclusions:
---------------

We have tested program huge-count.pl enough to conclude that it runs 
correctly. We have also provided the test scripts so that future versions of 
huge-count.pl can be compared to the current version against these scripts.

