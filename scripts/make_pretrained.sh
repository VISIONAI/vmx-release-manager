#!/bin/bash

cd /www/vmx/pretrained
files=(`find . -type f -not -name "*json"`)
LEN=`find . -type f -not -name "*json" | wc -l`
cd - > /dev/null 2>&1
LENMINUS=`expr $LEN - 1`
LENMINUS2=`expr $LEN - 2`

echo -n "{\"data\":["
for i in `seq 0 $LENMINUS2`;
do
    
    #echo i is $i
    file=${files[$i]}
    file=`echo $file | sed 's/\.\///g'`
    #echo "----file is \"$file\""
    hash=`md5sum /www/vmx/pretrained/$file | awk '{print($1)}'`
    sizer=`ls -l /www/vmx/pretrained/$file | awk '{print($5)}'`
    echo -n "{\"md5\":\"$hash\",\"file\":\"$file\",\"size\":$sizer},"
done

    file=${files[$LENMINUS]}
    file=`echo $file | sed 's/\.\///g'`

    hash=`md5sum /www/vmx/pretrained/$file | awk '{print($1)}'`
    sizer=`ls -l /www/vmx/pretrained/$file | awk '{print($5)}'`
    echo -n "{\"md5\":\"$hash\",\"file\":\"$file\",\"size\":$sizer}]}"
