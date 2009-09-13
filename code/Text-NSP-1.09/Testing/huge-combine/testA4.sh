#!/bin/csh

echo "Test A4 for huge-combine.pl"
echo "Running huge-combine.pl test-A4.count1 test-A4.count2"

huge-combine.pl test-A4.count1 test-A4.count2 > test-A4.output

sort test-A4.output > t0
sort test-A4.reqd > t1

diff t0 t1 > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A4.reqd";
	cat var;
endif

/bin/rm -f t0 t1 var test-A4.output
