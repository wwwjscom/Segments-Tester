#!/bin/csh

echo "Test B2 for huge-count.pl"
echo "Running huge-count.pl test-B2.output test-B2.data"

huge-count.pl test-B2.output test-B2.data >& test-B2.err

diff -w test-B2.err test-B2.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-B2.reqd";
	cat var;
endif

/bin/rm -f -r var test-B2.output test-B2.err
