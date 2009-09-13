#!/bin/csh

echo "Test B1 for sort-bigrams.pl"
echo "Running sort-bigrams.pl test-B1.bigram"

sort-bigrams.pl test-B1.bigram >& test-B1.output

diff -w test-B1.output test-B1.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-B1.reqd";
	cat var;
endif

/bin/rm -f var test-B1.output 
