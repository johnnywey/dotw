#!/bin/bash

twitPicCode=$1

downloadFile () {
     if ls -ld ${thisDir}/twitter/twitpic_media 2> /dev/null ; then
      printf "The posts directory already exists.\n"
     else
      mkdir ${thisDir}/twitter/twitpic_media
    fi
    url="https://twitpic.com/${twitPicCode}"
    curl --compressed ${url} --output - | grep 'src=\".*\"' | cut -d"\"" -f2 | xargs wget -O twitter/twitpic_media/${twitPicCode}.jpg
}

downloadFile
