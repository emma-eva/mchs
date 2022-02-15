#!/usr/bin/bash

SDCARD_DEB_PATH=/sdcard/McHs/pool/main
MCHS_PREFIX='/data/data/com.mchs/files/usr'

for DEB_FILES in $SDCARD_DEB_PATH/*/*/*.deb;
do
	DEB_PATH=(${DEB_FILES//\// })
	DEB_URL=$SDCARD_DEB_PATH/${DEB_PATH[4]}/${DEB_PATH[5]}/${DEB_PATH[6]}
	DEB_FILE_PATH=$SDCARD_DEB_PATH/${DEB_PATH[4]}/${DEB_PATH[5]}

	if [ ! -d ~/build/mchspkg ];
	then
		mkdir -p ~/build/mchspkg/DEBIAN ~/build/mchspkg$MCHS_PREFIX/bin
		touch ~/build/mchspkg/DEBIAN/control
	fi
	mkdir ~/build/debs
	cp $DEB_URL ~/build/debs
	ar x ~/build/debs/*.deb --output ~/build/debs
	mkdir ~/build/debs/control
	if [ -f ~/build/debs/control.tar.xz ];
	then
		tar -xf ~/build/debs/control.tar.xz -C ~/build/debs/control
	else
		tar -xf ~/build/debs/control.tar.gz -C ~/build/debs/control
	fi
	if [ -f ~/build/mchspkg/DEBIAN/control ];
	then
		rm -rf ~/build/mchspkg/DEBIAN/*
		mv ~/build/debs/control/* ~/build/mchspkg/DEBIAN
	else
		IN="${DEB_URL##*/}"
		arrIN=(${IN//_/ })
		touch ~/build/mchspkg/DEBIAN/control
		printf "Package: ${arrIN[0]}\nArchitecture: ${arrIN[2]:0:-4}\nMaintainer: @MCHS\nVersion: ${arrIN[1]}\nHomepage: https://tuberboy.com/MCHS\nDescription: Not Found Enough Information" >> ~/build/mchspkg/DEBIAN/control
	fi
	if [ -f ~/build/debs/data.tar.xz ];
	then
		tar -xf ~/build/debs/data.tar.xz -C ~/build/debs
	else
		tar -xf ~/build/debs/data.tar.gz -C ~/build/debs
	fi

	rm -rf ~/build/mchspkg$MCHS_PREFIX/*
	mv ~/build/debs/data/data/*/files/usr/* ~/build/mchspkg$MCHS_PREFIX/
	echo '\n\n Building McHs Package...'
	echo ' Please wait...'
	find ~/build/mchspkg/DEBIAN/* -type f -exec sed -i -e 's/io.neoterm/com.mchs/g' {} \;
	find ~/build/mchspkg/DEBIAN/* -type f -exec sed -i -e 's/@termux/@McHs/g' {} \;
	find ~/build/mchspkg$MCHS_PREFIX/./ -type f -exec sed -i -e 's/io.neoterm/com.mchs/g' {} \;
	#find ~/build/mchspkg$MCHS_PREFIX/./ -type f -exec sed -i -e 's/termux-build/mchs-build/g' {} \;
	chmod 755 ~/build/mchspkg/DEBIAN/*
	chmod 755 ~/build/mchspkg/DEBIAN
	if [ -d ~/build/mchspkg$MCHS_PREFIX/bin ];
	then
		chmod +x ~/build/mchspkg$MCHS_PREFIX/bin/*
	fi
	if [ -d ~/build/mchspkg$MCHS_PREFIX/lib* ];
	then
		chmod +x ~/build/mchspkg$MCHS_PREFIX/lib*/*
	fi
	dpkg-deb --build ~/build/mchspkg ${DEB_URL##*/}
	rm -rf ~/build/debs
	rm -rf ~/build/mchspkg
	echo '\n\n Build Finished Successfully'
	mv ${DEB_PATH[6]} $DEB_FILE_PATH
	printf ' Moved File: %s To: %s\n\n' "${DEB_PATH[6]}" "$DEB_FILE_PATH"
done
