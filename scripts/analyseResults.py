#!/usr/bin/python3

import json

inDataFile = 'programSizes.json'
outDataFile = 'programResults.json'
programTypes = [
        'Single file C Program',
        'Single file CPP Program',
        'C Style Modules with Callbacks',
        'Full Static CPP Class with Callbacks',
        'Concrete CPP Class',
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

for i in range(4,len(rows)):
    outData[programTypes[i-4]].append(int(rows[i]['total']))


with open(outDataFile,'w') as writeFile:
    json.dump(outData,writeFile,indent=4)
