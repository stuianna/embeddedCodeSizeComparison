#!/usr/bin/python3

import json
import matplotlib.pyplot as plt

datafile = 'programResults.json'
xAxisLabel = "Number of 'Polymorphic' Functions"
yAxisLabel = "Total Binary Size (bytes)"

with open(datafile,'r') as readFile:
    data = json.load(readFile)

ax = plt.subplot(111)

for i,key in enumerate(data.keys()):
    xValues = [str(i + 1) for i in range(0,len((data)[key]))]
    ax.plot(xValues,data[key])

plt.xlabel(xAxisLabel);
plt.ylabel(yAxisLabel);
ax.legend(data.keys(),loc='upper center',bbox_to_anchor=(0.5,-0.15),ncol=2,shadow=True,prop={'size':9});
box = ax.get_position()
ax.set_position([box.x0, box.y0 + box.height * 0.2,
                 box.width, box.height * 0.9])
plt.savefig('resultsGraph.png')
