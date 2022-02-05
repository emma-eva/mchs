#!/bin/bash 
PKG="mchspkg"
DATA="mbd.tar"
rm -rf ./$PKG
rm ./i.py
tar -xvf ./$DATA
echo "MCHS New Project Created: $PKG"
