#!/bin/python3
import os
import sys
import i
from i import *

pkg_data = open("./mchspkg/DEBIAN/control", "w+")
pkg_data.write(f"Package: {MCHS_PKG_NAME}\n")
pkg_data.write(f"Architecture: {MCHS_PKG_ARCH}\n")
pkg_data.write(f"Maintainer: {MCHS_PKG_MAINTAINER}\n")
pkg_data.write(f"Version: {MCHS_PKG_VERSION}\n")
pkg_data.write(f"Homepage: {MCHS_PKG_HOMEPAGE}\n")
pkg_data.write(f"Depends: {MCHS_PKG_DEPENDS}\n")
pkg_data.write(f"Installed-Size: {MCHS_PKG_SIZE}\n")
pkg_data.write(f"Description: {MCHS_PKG_DESCRIPTION}\n")
pkg_data.close

print("Building MCHS Package...")
os.system("chmod 755 ./mchspkg/DEBIAN/*")
os.system("chmod 755 ./mchspkg/DEBIAN")
os.system("chmod +x ./mchspkg$PREFIX/bin/*")
os.system(f"dpkg-deb --build ./mchspkg {MCHS_PKG_NAME}_{MCHS_PKG_VERSION}_{MCHS_PKG_ARCH}.deb")
