#!/bin/bash
rm -rf debian-os-image
rm core.sh
git clone https://github.com/alainpham/debian-os-image.git
ln -s debian-os-image/setup-scripts/core.sh ./core.sh
