#!/bin/csh

echo "Test A5 for huge-combine.pl"
echo "Running huge-combine.pl test-A5.count1 test-A5.count2"

huge-combine.pl test-A5.count1 test-A5.count2 > test-A5.output

sort test-A5.output > t0
sort test-A5.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A5.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A5.output
