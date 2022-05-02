#!/bin/sh
# bash script to replace the raspberryUsername in all files

#for all files in the directory, replace the username with the current user name

for f in *; do
    sed -i "s/raspberryUsername/$USER/g" $f
done