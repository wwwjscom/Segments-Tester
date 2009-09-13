*******************************************************************************

		     README.txt FOR Testing split-data.pl

                               Version 0.01
                         Copyright (C) 2002-2004
                       Ted Pedersen, tpederse@umn.edu
                    Amruta Purandare pura0010@d.umn.edu
                       University of Minnesota, Duluth

		   http://www.d.umn.edu/~tpederse/nsp.html

*******************************************************************************


Testing for split-data.pl
------------------------

AMRUTA PURANDARE
pura0010@d.umn.edu
02/23/2004

1. Introduction: 
----------------

This program is a component of the N-gram Statistics Package that splits 
a given big data file into smaller parts.
The scripts and files provided here could be used to test the correct 
behaviour of the program and backward compatibility. 

2. Tests:
----------

2.1 Normal conditions:
----------------------

Tests written in testA*.sh test split-data.pl under normal conditions.
Run normal-op.sh to run all test cases testA*.sh 

Test A1:	Tests split-data when each part has exactly same #lines
		In other words, #lines/#parts is a whole number

Test A2:	Tests split-data when #lines/#parts > 1 

Test A3:	Tests split-data when #parts = 1

Test A4:	Tests split-data when #parts = #lines or #lines/#parts = 1

2.2 Error conditions:
----------------------

Tests written in testB*.sh test split-data.pl under error conditions.
Run error-op.sh to run all test cases testB*.sh

Test B1:	Tests split-data when #parts > #lines or #lines/#parts < 1

3. Conclusions:
---------------

We have tested program split-data.pl enough to conclude that it runs correctly.
We have also provided the test scripts so that future versions of 
split-data.pl can be compared to the current version against these scripts.

