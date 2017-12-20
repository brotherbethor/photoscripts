#!/bin/bash

###########################################################################
# This scripts resizes pictures in a directory to either a set width or   #
# height. If neither is given, half of the original size is used.         #
# mogrify tutorial: http://redskiesatnight.com/?s=unsharp                 #
# known bugs: the target directory must not contain non-image files.      #
###########################################################################

source shflags

### Define commandline args ###
DEFINE_string 'target' '' 'target directory to work on' 't'
DEFINE_string 'width' '' 'resize image width to this size' 'w'

# boilerplate for shflags
ORIGINAL_ARGS="$@"
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

# was -h used?
if [ ${FLAGS_help} -eq ${FLAGS_TRUE} ]
then
    exit 0
fi

set -e
set -u

targetdirectory="${FLAGS_target}"
newsetwidth=""
newwidth="${FLAGS_width}"

if [ -d "${targetdirectory}" ]
then
    cd "${targetdirectory}"
else
    echo "Need directory as first parameter"
    flags_help
    exit 1
fi

if [ -n "${newwidth}" ]
then
    newsetwidth="${newwidth}"
fi

set -u

# TODO: use array of image types
jpgcount=`find . -type f -iname "*.jpg" | wc -l`
find . -type f -iname "*.jpg" | while read filename
   do
       newname="${filename%????}"
       newname="${newname#??}.jpg"
       width=`identify -format '%w' "${filename}"`
       if [ -z $newsetwidth ]
       then
           newwidth="$[${width}/2]"
       else
           newwidth=$newsetwidth
       fi
       convert -resize "${newwidth}" -quality 90 "${filename}" "${newname}"
   done
echo "converted ${jpgcount} images"
