#!/bin/bash -e
set -x
echo "halting mod\n"

sudo service mod-ui stop
sudo service mod-host stop
sudo service browsepy stop
sudo service jack stop