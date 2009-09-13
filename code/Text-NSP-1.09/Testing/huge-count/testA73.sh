#!/bin/csh

echo "Test A73 for huge-count.pl"
echo "Running huge-count.pl --token token.regex --nontoken nontoken.regex --stop stoplist test-A73.output test-A73.data1 test-A73.data2 test-A73.data3 test-A73.data4"

huge-count.pl --token token.regex --nontoken nontoken.regex --stop stoplist test-A73.output test-A73.data1 test-A73.data2 test-A73.data3 test-A73.data4

# testing count

foreach i (1 2 3 4)
	sort test-A73.output/test-A73.data$i.bigrams > t0
	sort test-A7.reqd/test-A7.data$i.bigrams > t1
	diff t0 t1 > var$i
end

if(-z var1 && -z var2 && -z var3 && -z var4) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A7.reqd/test-A7.data1.bigrams";
        cat var1;
        echo "When tested against test-A7.reqd/test-A7.data2.bigrams";
        cat var2;
        echo "When tested against test-A7.reqd/test-A7.data3.bigrams";
        cat var3;
        echo "When tested against test-A7.reqd/test-A7.data4.bigrams";
        cat var4;
endif

/bin/rm -f var1 var2 var3 var4 t0 t1

# testing final output

sort test-A73.output/huge-count.output > t0
sort test-A7.reqd/huge-count.output > t1

diff -w t0 t1 > var1

if(-z var1) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A7.reqd/huge-count.output";
        cat var1;
endif

/bin/rm -f -r var1 t0 t1 test-A73.output
