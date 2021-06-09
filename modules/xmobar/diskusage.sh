#!/bin/sh

usage=`df -H /home/itzmjauz --output=used,size | awk 'NR>1{printf "%s/%s", $1, $2}'`

echo $usage
exit 0
