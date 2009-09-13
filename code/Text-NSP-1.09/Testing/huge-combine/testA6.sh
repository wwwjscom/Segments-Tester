#!/bin/csh

echo "Test A6 for huge-combine.pl"
echo "Running huge-combine.pl test-A6.count1 test-A6.count2"

huge-combine.pl test-A6.count1 test-A6.count2 > test-A6.output

sort test-A6.output > t0
sort test-A6.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A6.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A6.output
