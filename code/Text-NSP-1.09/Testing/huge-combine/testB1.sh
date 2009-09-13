#!/bin/csh

echo "Test B1 for huge-combine.pl"
echo "Running huge-combine.pl test-B1.count1 test-B1.count2"

huge-combine.pl test-B1.count1 test-B1.count2 >& test-B1.output

sort test-B1.output > t0
sort test-B1.reqd > t1

diff -w t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-B1.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-B1.output
