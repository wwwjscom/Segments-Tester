#!/bin/csh

echo "Test A61 for huge-count.pl"
echo "Running huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --split 4 --remove 2 test-A61.output test-A61.data"

huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --split 4 --remove 2 test-A61.output test-A61.data

# testing only the final output

sort test-A61.output/huge-count.output > t0
sort test-A6.reqd > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A6.reqd";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A61.output

echo "Running huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --remove 2 test-A62.output test-A62.data"

huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --remove 2 test-A62.output test-A62.data

sort test-A62.output/huge-count.output > t0
sort test-A6.reqd > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A6.reqd";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A62.output

echo "Running huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --remove 2 test-A63.output test-A63.data1 test-A63.data2 test-A63.data3 test-A63.data4"

huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --remove 2 test-A63.output test-A63.data1 test-A63.data2 test-A63.data3 test-A63.data4

sort test-A63.output/huge-count.output > t0
sort test-A6.reqd > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A6.reqd";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A63.output

