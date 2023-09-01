#!/bin/bash -e
set -x
echo "halting mod"

sudo service mod-ui stop
sudo service mod-host stop
sudo service browsepy stop
sudo service mod-midi-merger-broadcaster start
sudo service mod-midi-merger start
sudo service jack stop