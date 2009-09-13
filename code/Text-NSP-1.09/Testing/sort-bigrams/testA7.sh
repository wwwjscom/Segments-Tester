#!/bin/csh

echo "Test A7 for sort-bigrams.pl"
echo "Running sort-bigrams.pl --remove 2 test-A71.bigram"

sort-bigrams.pl --remove 2 test-A71.bigram > test-A71.output

diff -w test-A71.output test-A71.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A71.reqd";
	cat var;
endif

/bin/rm -f var test-A71.output 

echo "Running sort-bigrams.pl --remove 2 test-A72.bigram"

sort-bigrams.pl --remove 2 test-A72.bigram > test-A72.output

diff -w test-A72.output test-A72.reqd > var

if(-z var) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A72.reqd";
        cat var;
endif

/bin/rm -f var test-A72.output
