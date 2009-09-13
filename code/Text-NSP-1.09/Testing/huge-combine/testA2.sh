#!/bin/csh

echo "Test A2 for huge-combine.pl"
echo "Running huge-combine.pl test-A2.count1 test-A2.count2"

huge-combine.pl test-A2.count1 test-A2.count2 > test-A2.output

sort test-A2.output > t0
sort test-A2.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A2.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A2.output
