#!/bin/bash

###########################################################################
# This script deletes all raw photos in a specified folder that have no   #
# matching jpeg file in another specified folder.                         #
# This allows me to shoot in JPEG/RAW, sort the jpg files and then this   #
# script removes the corresponding raw pictures so that I can work on the #
# ones I did not delete.                                                  #
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


# re-define shflag variables for ease of use
basepath="${FLAGS_basepath}"
jpgfoldername="${FLAGS_jpgfoldername}"
rawfoldername="${FLAGS_rawfoldername}"

if [ ! -d "${basepath}" ]
then
    echo "ERROR"
    echo "need existing directory as first parameter!"
    flags_help
    exit 1
fi

jpegdir="${basepath}/${jpgfoldername}"
rawdir="${basepath}/${rawfoldername}"

if [ ! -d "${rawdir}" ]
then
    echo "ERROR"
    echo "need existing directory RAW as subdirectory of basedir"
    echo "exiting"
    flags_help
    exit 1
fi

if [ ! -d "${jpegdir}" ]
then
    echo "ERROR"
    echo "need existing directory JPG as subdirectory of basedir"
    echo "exiting"
    flags_help
    exit 1
fi

cd "${rawdir}"

arwcount_before=`find . -type f -iname "*.arw" | wc -l`
rw2count_before=`find . -type f -iname "*.rw2" | wc -l`
echo ""
find . -type f -iname "*.arw" | while read rawname
do  
    fname="${rawname#??}"
    fname="${fname%????}"
    jname="${jpegdir}/${fname}.JPG"
    if [ ! -f "${jname}" ] 
    then
        rm "${rawname}"
    fi
done

find . -type f -iname "*.rw2" | while read rawname
do  
    fname="${rawname#??}"
    fname="${fname%????}"
    jname="${jpegdir}/${fname}.JPG"
    if [ ! -f "${jname}" ] 
    then
        rm "${rawname}"
    fi
done

arwcount_after=`find . -type f -iname "*.arw" | wc -l`
rw2count_after=`find . -type f -iname "*.rw2" | wc -l`

echo "arwcount before:after is ${arwcount_before}:${arwcount_after}"
echo "rw2count before:after is ${rw2count_before}:${rw2count_after}"

echo "all done"
