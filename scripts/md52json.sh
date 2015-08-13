#!/bin/bash

# Takes the MDSUMS.txt file which is in the same directory as the
# .tar.gz files and converts them to a JSON format

INPUT_FILE=$1

LEN=`cat $INPUT_FILE | wc -l`
LAST=`expr $LEN - 2`
hashes=($(tail -$LAST $INPUT_FILE | awk '{print($1)}'))
fnames=($(tail -$LAST $INPUT_FILE | awk '{print($2)}'))
#L=`cat $INPUT_FILE | wc -l`
Lfinal=`expr $LAST - 1`
L=`expr $Lfinal - 1`

hash_latest=($(head -1 $INPUT_FILE | awk '{print($1)}'))
fname_latest=($(head -1 $INPUT_FILE | awk '{print($2)}'))
real_latest=($(tail -$LAST $INPUT_FILE | grep $hash_latest | awk '{print($2)}'))
size_latest=`ls -l $real_latest | awk '{print($5)}'`

hash_stable=($(head -2 $INPUT_FILE | tail -1 | awk '{print($1)}'))
fname_stable=($(head -2 $INPUT_FILE | tail -1 | awk '{print($2)}'))
real_stable=($(tail -$LAST $INPUT_FILE | grep $hash_stable | awk '{print($2)}'))
size_stable=`ls -l $real_stable | awk '{print($5)}'`

echo -n "{\"latest\":{\"md5\":\"${hash_latest}\",\"link\":\"${fname_latest}\",\"file\":\"${real_latest}\",\"size\":$size_latest},"
echo -n "\"stable\":{\"md5\":\"${hash_stable}\",\"link\":\"${fname_stable}\",\"file\":\"${real_stable}\",\"size\":$size_stable}" 


echo -n "}"
exit

echo -n ",\"data\":["
for i in `seq 0 $L`; do
    hash=${hashes[$i]}
    fname=${fnames[$i]}
    sizer=`ls -l $fname | awk '{print($5)}'`
    echo -n "{\"md5\":\"$hash\",\"file\":\"$fname\",\"size\":$sizer},"
done

hash=${hashes[$Lfinal]}
fname=${fnames[$Lfinal]}
sizer=`ls -l $fname | awk '{print($5)}'`
echo "{\"md5\":\"$hash\",\"file\":\"$fname\",\"size\":$sizer}]}"
