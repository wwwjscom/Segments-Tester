#!/bin/csh

echo "Test A2 for sort-bigrams.pl"
echo "Running sort-bigrams.pl test-A2.bigram"

sort-bigrams.pl test-A2.bigram > test-A2.output

diff test-A2.output test-A2.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A2.reqd";
	cat var;
endif

/bin/rm -f var test-A2.output 
