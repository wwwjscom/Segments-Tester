#!/bin/csh

echo "Test B2 for huge-combine.pl"
echo "Running huge-combine.pl test-B2.count1 test-B2.count2"

huge-combine.pl test-B2.count1 test-B2.count2 >& test-B2.output

sort test-B2.output > t0
sort test-B2.reqd > t1

diff -w t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-B2.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-B2.output
