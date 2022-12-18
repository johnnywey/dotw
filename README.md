### Updates by JohnnyWey

I've been on Twitter for a long time. Perhaps, like many of you, I wanted to have a copy of my activity that is easily surfaced. What better tool than DayOne!

The difference between the original script and this one is that I had a lot of my media stored in Twitpic prior to Twitter supporting native media. I wanted to add those to DayOne also.

The script looks for Twitpic links in either the `expanded_url` section or the body. If they exist, it will download them to `twitter/twitpic_media` and then add them to DayOne. It (perhaps) niavely assumes the image is a jpg.

Outside of this, the biggest difference between this and the original is I expect the `tweets.js` file to exist in the same directly as the script - just to make things easier on me.

Otherwise, please follow the same instructions as the original to download your Twitter archive, etc. I've preserved them below.

### Original
Day One <- Twitter

The dotw.bash script allows you to suck Twitter posts into your Day One journal.

This tool is Specifically written to be run on a Mac via a bash shell; but you may run it on a Windows host if you install a tool like mobaXterm.

NOTE! This tool is designed to import the Date and Text of your post only. More may come in the future; but this is the meat of this project for now.

FORGET THAT NOTE! :D New and improved in February 2019 to now import your (first) post pic and tags as well!

Another note: My Twitter export didn't start showing time of day until about Dec 2010... so if you're an old-timer like me, you might not have time shown in your earliest posts. (...so it defaults to 1am to make you look cool, staying up late and stuff.)

Before you run the script, you will need to download your Twitter posts.

- Log in to your Twitter account.

- Click on your avatar in the top right, and click Settings and Privacy.

- Scroll down to the bottom, and click request your archive.

- Download the .zip file from Twitter, and unzip it into a folder called "dotw" in your home directory (i.e. /Users/kitykity/dotw).

- After you unzip the folder from Twitter, name it "twitter" (all lowercase) instead of the big stupid name they give it.

- Copy the dotw.bash listed above into the directory called dotw that you made earlier.

$ cd /Users/fred/dotw

$ chmod 700 dotw.bash

$ ./dotw.bash

That's it! Enjoy!
