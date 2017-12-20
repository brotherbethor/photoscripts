#!/bin/bash

###########################################################################
# This script creates two subfolders in a specified base directory, one   #
# for jpeg pictures and one for raw pictures.                             #
# It then moves all pictures out of the base directory and into their     #
# corresponding directories.                                              #
# This allows me to shoot in JPEG/RAW, copy all files to disk and then    #
# prepare the folder automatically so that I can sort the jpg files.      #
###########################################################################


source shflags

### Define commandline args ###
DEFINE_string 'basepath' '' 'target directory to work on' 'b'
DEFINE_string 'jpgfoldername' 'JPG' 'name of subdirectory of  jpg files. default JPG.' 'j'
DEFINE_string 'rawfoldername' 'RAW' 'name of subdirectory of raw files. default RAW.' 'r'

# boilerplate for shflags
ORIGINAL_ARGS="$@"
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

# was -h used?
if [ ${FLAGS_help} -eq ${FLAGS_TRUE} ]
then
    exit 0
fi

# do not set them before this point, shflags does not like them
set -e
set -u

# redefine variables for ease of use
basepath="${FLAGS_basepath}"

set -u

if [ ! -d "${basepath}" ]
then
    echo "ERROR"
    echo "need existing directory as first parameter!"
    flags_help
    exit 1
fi

jpegdir="${basepath}/JPEG"
rawdir="${basepath}/RAW"

if [ -d "${jpegdir}" ]
then
    echo "ERROR"
    echo "Directory for JPG files exists: $jpegdir"
    flags_help
    exit 1
fi

if [ -d "${rawdir}" ]
then
    echo "ERROR"
    echo "Directory for RAW files exists: $rawdir"
    flags_help
    exit 1
fi

mkdir -p "${jpegdir}"
echo "created ${jpegdir}"
mkdir -p "${rawdir}"
echo "created ${rawdir}"


cd "${basepath}"

rw2count=`find . -type f -iname "*.rw2" | wc -l`
find . -type f -iname "*.rw2" | while read rawname
do  
    fname="${rawname#??}"
    mv "${fname}" "${rawdir}/${fname}"
done
echo "done copying ${rw2count} RW2 files"

arwcount=`find . -type f -iname "*.arw" | wc -l`
find . -type f -iname "*.arw" | while read rawname
do  
    fname="${rawname#??}"
    mv "${fname}" "${rawdir}/${fname}"
done
echo "done copying ARW files"

jpgcount=`find . -type f -iname "*.jpg" | wc -l`
find . -type f -iname "*.jpg" | while read rawname
do  
    fname="${rawname#??}"
    mv "${fname}" "${jpegdir}/${fname}"
done
echo "done copying ${jpgcount} JPG files"
echo "done with script"



