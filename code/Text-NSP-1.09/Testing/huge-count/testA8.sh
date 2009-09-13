#!/bin/csh

echo "Test A81 for huge-count.pl"
echo "Comparing huge-count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --split 4 test-A81.huge-count test-A81.data"
echo "Against"
echo "count.pl --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A8.count test-A81.data"

huge-count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist --split 4 test-A81.huge-count test-A81.data

sort test-A81.huge-count/huge-count.output > t0
sort test-A8.count > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A8.count";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A81.huge-count 

echo "Comparing huge-count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A82.huge-count test-A82.data"
echo "Against"
echo "count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A8.count test-A82.data"

huge-count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A82.huge-count test-A82.data

sort test-A82.huge-count/huge-count.output > t0
sort test-A8.count > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A8.count";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A82.huge-count 

echo "Comparing huge-count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A83.huge-count test-A83.data1 test-A83.data2 test-A83.data3 test-A83.data4"
echo "Against"
echo "count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A8.count test-A83.data"

huge-count.pl  --newLine --token token.regex --nontoken nontoken.regex --stop stoplist test-A83.huge-count test-A83.data1 test-A83.data2 test-A83.data3 test-A83.data4 

sort test-A83.huge-count/huge-count.output > t0
sort test-A8.count > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A8.count";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A83.huge-count
