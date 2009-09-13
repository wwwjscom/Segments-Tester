#!/bin/csh

echo "Test A41 for huge-count.pl"
echo "Running huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --split 4 --frequency 2 test-A41.output test-A41.data"

huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --split 4 --frequency 2 test-A41.output test-A41.data

# testing only the final output

sort test-A41.output/huge-count.output > t0
sort test-A41.reqd > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A41.reqd";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A41.output

echo "Running huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --frequency 2 test-A42.output test-A42.data"

huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --frequency 2 test-A42.output test-A42.data

sort test-A42.output/huge-count.output > t0
sort test-A42.reqd > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A42.reqd";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A42.output

echo "Running huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --frequency 2 test-A43.output test-A43.data1 test-A43.data2 test-A43.data3 test-A43.data4"

huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --frequency 2 test-A43.output test-A43.data1 test-A43.data2 test-A43.data3 test-A43.data4

sort test-A43.output/huge-count.output > t0
sort test-A43.reqd > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A43.reqd";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A43.output
