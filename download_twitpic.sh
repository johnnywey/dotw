#!/bin/bash

twitPicCode=$1

downloadFile () {
    url="https://twitpic.com/${twitPicCode}"
    curl --compressed ${url} --output - | grep 'src=\".*\"' | cut -d"\"" -f2 | xargs wget -O twitter/twitpic_media/${twitPicCode}.jpg
}

downloadFile
