#!/bin/bash

TABLEHEADINGS="Program Type,Text,Data,BSS,Total,Relative Size"
TABLENAME="Binary Size Comparison"

# Get the smallest binary size

MINSIZE=10000
for binary in "$@"
do
	if [ -f "$binary" ];
	then
		BININFO=$(arm-none-eabi-size "$binary" | tail -1)
		BINTOTAL=$(echo "$BININFO" | awk '{print $4};')
		if [ "$BINTOTAL" -lt "$MINSIZE" ];
		then
			MINSIZE=$BINTOTAL
		fi
	fi
done

for binary in "$@"
do
	if [ -f "$binary" ];
	then
		BININFO=$(arm-none-eabi-size "$binary" | tail -1)
		BINTEXT=$(echo "$BININFO" | awk '{print $1};')
		BINDATA=$(echo "$BININFO" | awk '{print $2};')
		BINBSS=$(echo "$BININFO" | awk '{print $3};')
		BINTOTAL=$(echo "$BININFO" | awk '{print $4};')
		SIZEINC=$(echo "scale=6;($BINTOTAL / $MINSIZE) * 100.0" | bc -l | sed 's/\([0-9]*.[0-9][0-9]\).*/\1/')
		TABLE+="$BINTEXT,$BINDATA,$BINBSS,$BINTOTAL,$SIZEINC %%"
		TABLE+="\n"
	else
		TABLE+="$binary,"
	fi
done

printf "$TABLE" | column -t -o " | " -s "," -N "$TABLEHEADINGS" -n "$TABLENAME" 
