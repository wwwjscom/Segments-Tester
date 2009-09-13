#!/bin/csh

echo "Test A4 for split-data.pl"
echo "Running split-data.pl --parts 4 test-A4.data"

split-data.pl --parts 4 test-A4.data

diff test-A4.data1 test-A4.data1.reqd > var1
diff test-A4.data2 test-A4.data2.reqd > var2
diff test-A4.data3 test-A4.data3.reqd > var3
diff test-A4.data4 test-A4.data4.reqd > var4

if(-z var1 && -z var2 && -z var3 && -z var4) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A4.data1.reqd";
	cat var1;
	echo "When tested against test-A4.data2.reqd";
        cat var2;
	echo "When tested against test-A4.data3.reqd";
        cat var3;
	echo "When tested against test-A4.data4.reqd";
        cat var4;
endif

/bin/rm -f var1 var2 var3 var4 test-A4.data1 test-A4.data2 test-A4.data3 test-A4.data4
