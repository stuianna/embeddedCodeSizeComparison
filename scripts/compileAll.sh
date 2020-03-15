#!/bin/bash

rm programSizes.json
rm programResults.json

git checkout oneFunction
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout twoFunctions
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout threeFunctions
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout fourFunctions
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout fiveFunctions
make clean
make
$(pwd)/scripts/analyseResults.py

git checkout sixFunctions
make clean
make
$(pwd)/scripts/analyseResults.py

$(pwd)/scripts/graphResults.py
rm programResults.json
rm programSizes.json
feh resultsGraph.png
