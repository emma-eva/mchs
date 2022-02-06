#!/usr/bin/bash

if [ ! -d ~/mchs/mchspkg ];
then
    mkdir -p ~/mchs/mchspkg/DEBIAN ~/mchs/mchspkg$PREFIX/bin
	touch ~/mchs/mchspkg/DEBIAN/control
fi
read -p 'Enter direct deb file path: ' DEBURL
if [[ $DEBURL =~ https?:// ]]
then
	wget -P ~/mchs/debs $DEBURL
	ar x ~/mchs/debs/*.deb --output ~/mchs/debs
	mkdir ~/mchs/debs/control
	if [ -f ~/mchs/debs/control.tar.xz ];
	then
		tar -xf ~/mchs/debs/control.tar.xz -C ~/mchs/debs/control
	else
		tar -xf ~/mchs/debs/control.tar.gz -C ~/mchs/debs/control
	fi
	if [ -f ~/mchs/mchspkg/DEBIAN/control ];
	then
		rm -rf ~/mchs/mchspkg/DEBIAN/*
		mv ~/mchs/debs/control/* ~/mchs/mchspkg/DEBIAN
	else
		IN="${DEBURL##*/}"
		arrIN=(${IN//_/ })
		touch ~/mchs/mchspkg/DEBIAN/control
		printf "Package: ${arrIN[0]}\nArchitecture: ${arrIN[2]:0:-4}\nMaintainer: @MCHS\nVersion: ${arrIN[1]}\nHomepage: https://tuberboy.com/MCHS\nDescription: Not Found Enough Information" >> ~/mchs/mchspkg/DEBIAN/control
	fi
	if [ -f ~/mchs/debs/data.tar.xz ];
	then
		tar -xf ~/mchs/debs/data.tar.xz -C ~/mchs/debs
	else
		tar -xf ~/mchs/debs/data.tar.gz -C ~/mchs/debs
	fi
	rm -rf ~/mchs/mchspkg$PREFIX/*
	mv ~/mchs/debs/data/data/*/files/usr/* ~/mchs/mchspkg$PREFIX/
	echo 'Building MCHS Package...'
	echo ' Please wait...'
	find ~/mchs/mchspkg/DEBIAN/* -type f -exec sed -i -e 's/com.termux/io.neoterm/g' {} \;
	find ~/mchs/mchspkg/DEBIAN/* -type f -exec sed -i -e 's/@termux/@MCHS/g' {} \;
	find ~/mchs/mchspkg$PREFIX/./ -type f -exec sed -i -e 's/com.termux/io.neoterm/g' {} \;
	find ~/mchs/mchspkg$PREFIX/./ -type f -exec sed -i -e 's/termux-build/mchs-build/g' {} \;
	chmod 755 ~/mchs/mchspkg/DEBIAN/*
	chmod 755 ~/mchs/mchspkg/DEBIAN
	chmod +x ~/mchs/mchspkg$PREFIX/bin/*
	dpkg-deb --build ~/mchs/mchspkg ${DEBURL##*/}
	rm -rf ~/mchs/debs
else
	echo -e '\e[31mError:\e[0m Please enter a valid url with http(s)\n'
fi
