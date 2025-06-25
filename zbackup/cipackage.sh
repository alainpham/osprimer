#!/bin/bash
if [ -f "./authorized_keys" ] ; then
    echo packaging with authorized_keys
    tar cvf pack.tar scripts mac authorized_keys
else
    echo packaging without authorized_keys
    tar cvf pack.tar scripts mac 
fi
