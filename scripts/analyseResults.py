#!/usr/bin/python3

import json

inDataFile = 'programSizes.json'
outDataFile = 'programResults.json'
programTypes = [
        'Fully Static CPP Classes',
        'Concrete CPP Classes',
        'Polymorphic CPP Class with Virtual Functions',
        'CRTP Static Polymorphism']


with open(inDataFile,'r') as readFile:
    inData = json.load(readFile)

try:
    with open(outDataFile,'r') as readFile:
        outData = json.load(readFile)
except:
    outData = {key:[] for key in programTypes}


rows = inData['Binary Size Comparison']

for i in range(1,len(rows)):
    outData[programTypes[i-1]].append(int(rows[i]['total']))


with open(outDataFile,'w') as writeFile:
    json.dump(outData,writeFile,indent=4)
