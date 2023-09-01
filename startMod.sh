#!/bin/bash -e
set -x
echo "starting mod..."

sudo service jack start
sudo service mod-midi-merger start
sudo service mod-midi-merger-broadcaster start
sudo service browsepy start
sudo service mod-host start
sudo service mod-ui start