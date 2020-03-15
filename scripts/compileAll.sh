#!/bin/bash

rm programSizes.json
rm programResults.json

git checkout master
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout threeFunctions
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout fourFunctionIncThreePoly
make clean
make
$(pwd)/scripts/analyseResults.py

$(pwd)/scripts/graphResults.py
rm programResults.json
rm programSizes.json
feh resultsGraph.png
