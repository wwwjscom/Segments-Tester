#!/bin/csh

echo "Test A1 for huge-combine.pl"
echo "Running huge-combine.pl test-A1.count1 test-A1.count2"

huge-combine.pl test-A1.count1 test-A1.count2 > test-A1.output

sort test-A1.output > t0
sort test-A1.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A1.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A1.output
