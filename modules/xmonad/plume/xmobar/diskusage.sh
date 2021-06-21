#!/bin/sh

usage=`df -H /home/itzmjauz --output=used,size | awk 'NR>1{printf "%s/%s", $1, $2}'`
disk2=`df -H / --output=used | awk 'NR>1'`
disk_size=$(echo "${usage}" | cut -f2 -d/)
disk_1_use=$(echo "${usage}" | cut -f1 -d/ | cut -f1 -dG)
disk_2_use=$(echo "${disk2}" | cut -f1 -dG)
disk_use=$(($disk_1_use + $disk_2_use))

echo "${disk_use}G/${disk_size}"
exit 0
