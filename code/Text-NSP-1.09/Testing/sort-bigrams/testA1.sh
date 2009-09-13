#!/bin/csh

echo "Test A1 for sort-bigrams.pl"
echo "Running sort-bigrams.pl test-A1.bigram"

sort-bigrams.pl test-A1.bigram > test-A1.output

diff test-A1.output test-A1.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A1.reqd";
	cat var;
endif

/bin/rm -f var test-A1.output 
