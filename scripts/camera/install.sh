#!/bin/bash

files="c920 cint"
for file in $files; do
    sudo cp $file /usr/local/bin/$file
done