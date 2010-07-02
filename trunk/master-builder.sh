#!/bin/sh

## Written by playdude
## Feel free to modify, improve and of course share
## as this is GPL

AP110D_190_DIR="ap110d-1.90-source"
AP110D_190_DL="http://astone.googlecode.com/files/ap110d-1.90-source.tar.bz2"
AP110D_190_FILE="ap110d-1.90-source.tar.bz2"

# Takes download link as argument and downloads it with wget
download()
{
# Create dl directory to hold files if it hasn't been created yet
  if [ ! -d dl ]; then
    mkdir dl
  fi 
  echo "Downloading:" $1
  cd dl
  wget $1
}

case $1 in 
  ap110d-1.90)
  echo "Building firmware 1.90 for Astone ap110d..."

  # Download source file if it hasn't been downloaded to dl already
  if [ ! -e dl/$AP110D_190_FILE ]; then
    download $AP110D_190_DL
  fi
  
  # Extract files if they haven't been extracted already
  if [ ! -e $AP110D_190_DIR/.version1.90 ]; then 
    echo "Extracting files" 
    tar xvfj dl/$AP110D_190_FILE
  fi

  # Enter the directory and build the firmware
    cd $AP110D_190_DIR
    ./build.sh make
  ;;

  *)
  echo "Currently supported models:"
  echo "ap110d-1.90 - Astone ap110d 1.90 firmware"
  echo "Example: to build firmware 1.90 for the ap110d, run"
  echo "./master-builder ap110d-1.90"
  ;;
esac
