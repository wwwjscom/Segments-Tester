#!/bin/csh

echo "Test A6 for sort-bigrams.pl"
echo "Running sort-bigrams.pl --frequency 2 test-A61.bigram"

sort-bigrams.pl --frequency 2 test-A61.bigram > test-A61.output

diff test-A61.output test-A61.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A61.reqd";
	cat var;
endif

/bin/rm -f var test-A61.output 

echo "Running sort-bigrams.pl --frequency 90 test-A62.bigram"

sort-bigrams.pl --frequency 90 test-A62.bigram > test-A62.output

diff test-A62.output test-A62.reqd > var

if(-z var) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A62.reqd";
        cat var;
endif

/bin/rm -f var test-A62.output

echo "Running sort-bigrams.pl --frequency 10 test-A63.bigram"

sort-bigrams.pl --frequency 10 test-A63.bigram > test-A63.output

diff test-A63.output test-A63.reqd > var

if(-z var) then
        echo "Test Ok";
else
        echo "Test Error";
        echo "When tested against test-A63.reqd";
        cat var;
endif

/bin/rm -f var test-A63.output

