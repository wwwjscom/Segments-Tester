#!/bin/csh

echo "Test A4 for sort-bigrams.pl"
echo "Running sort-bigrams.pl test-A4.bigram"

sort-bigrams.pl test-A4.bigram > test-A4.output

diff test-A4.output test-A4.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A4.reqd";
	cat var;
endif

/bin/rm -f var test-A4.output 
