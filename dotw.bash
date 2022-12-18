#!/bin/bash
# dotw.bash
# Import Twitter posts into Day One.
# by Susan Pitman
# 11/14/14 Script created.
# 2/15/2019 Updated for dayone2. Added photo and tagging feature.

# Notes:
# 1. Change the twitter downloaded stuff directory name to "twitter."
# 2. Set your twitter username variable below. (Feel free to fix this; I was being lazy.)
# 3. Set your timezone variable below.

#set -x

thisDir=`pwd`
twitterUsername="johnnywey"
timeZone="GMT-7:00"

makePostFiles () {
    if ls -ld ${thisDir}/dotwPosts 2> /dev/null ; then
      printf "The posts directory already exists.\n"
     else
      mkdir ${thisDir}/dotwPosts
    fi
    fileNum="0"
    echo "" > "${thisDir}/dotwPosts/post.0"
      printf "Processing tweets.js file..."    
      # Each line in the monthly download file...
      while read thisLine ; do
      if echo ${thisLine} | grep "\"source\" :" > /dev/null ; then
        printf "."
        ((fileNum++))
        fileNumPadded=`printf %06d $fileNum`
        # Make a new file for each individual post.
        echo ${thisLine} > ${thisDir}/dotwPosts/post.${fileNumPadded}
       else
        echo ${thisLine} >> ${thisDir}/dotwPosts/post.${fileNumPadded}
      fi
  done < ${thisDir}/tweets.js
  printf "\n"
}

postPopper () {
  rm "${thisDir}/dotwPosts/post." "${thisDir}/dotwPosts/post.0" 2> /dev/null #Garbage file
  for fileName in `ls ${thisDir}/dotwPosts/p*` ; do
    postMedia=""
    postMediaUrl=""
    postMediaFilename=""
    postTags=""
    postDT=`grep "created_at" ${fileName} | cut -d"\"" -f4`
    postYear=`echo ${postDT} | cut -d" " -f6`
    postMonthWord=`echo ${postDT} | cut -d" " -f2`
    postMonth=`date -j -v${postMonthWord}m '+%m'`
    postDay=`echo ${postDT} | cut -d" " -f3`
    postTime=`echo ${postDT} | cut -d" " -f4`
    postHourGmt=`echo ${postDT} | cut -d" " -f4 | cut -d":" -f1`
    postMinute=`echo "${postDT}" | cut -d" " -f4 | cut -d":" -f2`
    postSecond=`echo "${postDT}" | cut -d" " -f4 | cut -d":" -f3`
    #TZ=US/Chicago date -jf "%Y-%m-%d %H:%M:%S %z" "2011-11-13 08:11:02 +0000" +"%Y_%m_%d__%H_%M_%S"
    postYear=`TZ="${timeZone}" date -jf "%Y-%m-%d %H:%M:%S %z" "${postYear}-${postMonth}-${postDay} ${postHourGmt}:${postMinute}:${postSecond} +0000" +%Y` 
    postMonth=`TZ="${timeZone}" date -jf "%Y-%m-%d %H:%M:%S %z" "${postYear}-${postMonth}-${postDay} ${postHourGmt}:${postMinute}:${postSecond} +0000" +%m` 
    postDay=`TZ="${timeZone}" date -jf "%Y-%m-%d %H:%M:%S %z" "${postYear}-${postMonth}-${postDay} ${postHourGmt}:${postMinute}:${postSecond} +0000" +%d` 
    postHour=`TZ="${timeZone}" date -jf "%Y-%m-%d %H:%M:%S %z" "${postYear}-${postMonth}-${postDay} ${postHourGmt}:${postMinute}:${postSecond} +0000" +%H` 
    postMinute=`TZ="${timeZone}" date -jf "%Y-%m-%d %H:%M:%S %z" "${postYear}-${postMonth}-${postDay} ${postHourGmt}:${postMinute}:${postSecond} +0000" +%M` 

#    if [ ${postHour} -gt "12" ] ; then
#      postHour=`expr ${postHour} - 12`
#      postAMPM="PM"
#     else
#      postAMPM="AM"
#    fi
#    if [ ${postHour} = "00" ] ; then
#      postTitle="Twitter Post"
#     else
### I gave up fighting with this. 
### If someone wants to figure out the time conversion, be my guest to clean up my mess...
#      postTitle="Twitter Post \@ ${postHour}\:${postMinute} ${postAMPM}"
      postTitle="Tweet \@ ${postHour}\:${postMinute}"
#    fi

    postId=`cat ${fileName} | sed -n '/favorite_/,$p' | sed -n "/favorited\"/q;p" | grep "id\"" | tail -2 | head -1 | cut -d"\"" -f4`
    postUrl="https://twitter.com/${twitterUsername}/status/${postId}"
    postFullText=`grep "\"full_text\"" ${fileName} | cut -d"\"" -f4 | sed 's/\"\,$//'`
    postTextComplete="${postTitle}\n\n${postFullText}\n${postText}\n\n<${postUrl}>\n"
    postDateTimeForDayOne="${postMonth}/${postDay}/${postYear} ${postHour}:${postMinute}${postAMPM}"
    printf "\nFilename: ${fileName}\n"

    # Get media. Default to media_url, but legacy Twitpic can exist in either expanded_url or post body.
    # Order of prefernce is media, expanded, post body.
    postMediaUrl=`grep "media_url\"" ${fileName} | head -1 | cut -d"\"" -f4`
    postExpandedUrl=`grep "expanded_url\"" ${fileName} | head -1 | cut -d"\"" -f4 | cut -d"/" -f4`
    postInBody=`grep "\"full_text\"" ${fileName} | cut -d"\"" -f4 | sed 's/\"\,$//' | sed 's/http/\nhttp/g' | grep "http:\/\/twitpic.com/[a-zA-Z0-9.-]*" | cut -d"/" -f4`
   
    if [ "${postMediaUrl}" != "" ] ; then
        postMedia=`basename ${postMediaUrl}`
        postMediaFilename=`find ${thisDir}/twitter/tweet_media -name "*${postMedia}" | egrep "jpg|png|gif"`
    elif [ "${postExpandedUrl}" != "" ] ; then
        ./download_twitpic.sh "$postExpandedUrl"
        postMediaFilename=`find ${thisDir}/twitter/twitpic_media -name "*${postExpandedUrl}.jpg"`
    elif [ "${postInBody}" != "" ] ; then
        ./download_twitpic.sh "$postInBody"
        postMediaFilename=`find ${thisDir}/twitter/twitpic_media -name "*${postInBody}.jpg"`
    fi
    
    printf "Post Date: ${postDateTimeForDayOne}\n"
    printf "Post Media File: ${postMediaFilename}\n"
    printf "Twitpic in Body: ${postInBody}\n"
    printf "Twitpic in expanded_url: ${postExpandedUrl}\n"

    if [ "${postMediaFilename}" != "" ] ; then
      printf "${postTextComplete}" | /usr/local/bin/dayone2 -p ${postMediaFilename} -t tweet -j Twitter -d="${postDateTimeForDayOne}" new 
    else 
      printf "${postTextComplete}" | /usr/local/bin/dayone2 -t tweet -j Twitter -d="${postDateTimeForDayOne}" new
    fi
    shortName=`echo ${fileName} | tr '/' '\n' | tail -1`
    mv ${fileName} ${thisDir}/dotwPosts/done.${shortName}
    printf "`ls ${thisDir}/dotwPosts/p* | wc -l` posts left to import.\n"
#    sleep 5
    # printf "Hit Enter for the next one... " ; read m
  done
}

## MAIN ##
makePostFiles
#postPopper
## END OF SCRIPT ##

