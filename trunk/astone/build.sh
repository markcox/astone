#!/bin/sh

## This is an attempt to automatically build the firmware
## for the Astone ap110d, a Realtek media player.
## Please feel free to adapt it for your Realtek
## media player or make further improvements, and of
## course share it as it is GPL.
## Written by playdude

case $1 in 

clean)

echo "##Trying to remove old image file install.img"
if [ -e FINAL-IMAGE/install.img ]
  then
  rm FINAL-IMAGE/install.img
  echo "##Old image file removed!"

else 
  echo "##Image file removal not needed. Not there!"
fi

echo "##Cleaning staging directory"
if [ ! -n "`ls -A ./staging`" ]
  then
  echo "##Cleaning not necessary since staging directory is empty."
else
rm -r ./staging/*
fi
echo "##Cleaning done!"
;;

make)

echo "##Cleaning staging directory"
if [ ! -n "`ls -A ./staging`" ]
  then
  echo "##Cleaning not necessary since staging directory is empty."
else
  rm -r ./staging/*
fi
echo "##Cleaning done!"

echo "##Copying relevant files to staging directory"
cp -a ./ap110d-1.90/* ./staging/
echo "##Copying done!"

echo "##Attempting to squash squashfs1 directory"
cd ./staging/package1/
../../tools/mksquashfs ./squashfs1 squashfs1.img
echo "##squashing done!"

echo "##Attempting to create usr.local.etc.tar.bz2 from usr.local.etc"
if [ -d usr.local.etc ]
  then
  cd ./usr.local.etc
  tar cfj ../usr.local.etc.tar.bz2 *
fi
echo "##user.local.etc.tar.bz2 done!"

echo "##Removing redundant files."
cd ../..
rm -r ./package1/squashfs1
rm -r ./package1/usr.local.etc
echo "##Redundant files removed!"

if [ -e ../FINAL-IMAGE/install.img ]
  then
  echo "##Remove old install.img file in FINAL-IMAGE"
fi
echo "##Old install.img file removed!"

echo "##Moment of truth: packaging install.img"
tar cvf ../FINAL-IMAGE/install.img *
echo "##install.img packaging done!"

echo "##Firmware image install.img should be in FINAL-IMAGE directory."
echo "##Happy bricking!"

;;

*)
echo "Build script for your Astone player."
echo "Usage: clean - clean all old files"
echo "       make  - make firmware image "
echo "For example, to build firmware image, run this: ./build make"
;;

esac
