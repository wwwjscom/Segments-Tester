#!/bin/csh

echo "Test A3 for huge-combine.pl"
echo "Running huge-combine.pl test-A3.count1 test-A3.count2"

huge-combine.pl test-A3.count1 test-A3.count2 > test-A3.output

sort test-A3.output > t0
sort test-A3.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A3.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A3.output
