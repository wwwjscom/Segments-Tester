#!/bin/csh

echo "Test A3 for sort-bigrams.pl"
echo "Running sort-bigrams.pl test-A3.bigram"

sort-bigrams.pl test-A3.bigram > test-A3.output

diff test-A3.output test-A3.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A3.reqd";
	cat var;
endif

/bin/rm -f var test-A3.output 
