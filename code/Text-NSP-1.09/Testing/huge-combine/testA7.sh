#!/bin/csh

echo "Test A7 for huge-combine.pl"
echo "Running huge-combine.pl test-A7.count1 test-A7.count2"

huge-combine.pl test-A7.count1 test-A7.count2 > test-A7.output

sort test-A7.output > t0
sort test-A7.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A7.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A7.output
