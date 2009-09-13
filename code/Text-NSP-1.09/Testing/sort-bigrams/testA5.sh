#!/bin/csh

echo "Test A5 for sort-bigrams.pl"
echo "Running sort-bigrams.pl test-A5.bigram"

sort-bigrams.pl test-A5.bigram > test-A5.output

diff test-A5.output test-A5.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A5.reqd";
	cat var;
endif

/bin/rm -f var test-A5.output 
