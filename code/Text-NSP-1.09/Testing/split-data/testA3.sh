#!/bin/csh

echo "Test A3 for split-data.pl"
echo "Running split-data.pl --parts 1 test-A3.data"

split-data.pl --parts 1 test-A3.data

diff test-A3.data1 test-A3.data1.reqd > var1

if(-z var1) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A3.data1.reqd";
	cat var1;
endif

/bin/rm -f var1 test-A3.data1 
