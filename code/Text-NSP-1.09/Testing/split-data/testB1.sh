#!/bin/csh

echo "Test B1 for split-data.pl"
echo "Running split-data.pl --parts 15 test-B1.data"

split-data.pl --parts 15 test-B1.data >& test-B1.output

sort test-B1.output > t0
sort test-B1.reqd > t1
diff -w t0 t1 > var1

if(-z var1) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-B1.reqd";
	cat var1;
endif

/bin/rm -f t0 t1 var1 test-B1.output
