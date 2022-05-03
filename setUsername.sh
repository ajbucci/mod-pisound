#!/bin/sh

echo "setting username to $USER for install script and services"

for f in *; do
    sed -i "s/raspberryUsername/$USER/g" $f
done