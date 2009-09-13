#!/bin/csh

echo "Test A2 for split-data.pl"
echo "Running split-data.pl --parts 3 test-A2.data"

split-data.pl --parts 3 test-A2.data

diff test-A2.data1 test-A2.data1.reqd > var1
diff test-A2.data2 test-A2.data2.reqd > var2
diff test-A2.data3 test-A2.data3.reqd > var3

if(-z var1 && -z var2 && -z var3) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A2.data1.reqd";
	cat var1;
	echo "When tested against test-A2.data2.reqd";
        cat var2;
	echo "When tested against test-A2.data3.reqd";
        cat var3;
endif

/bin/rm -f var1 var2 var3 test-A2.data1 test-A2.data2 test-A2.data3
