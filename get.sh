#!/bin/bash
rm -rf osprimer
rm core.sh
git clone https://github.com/alainpham/osprimer.git
ln -s osprimer/setup-scripts/core.sh ./core.sh
