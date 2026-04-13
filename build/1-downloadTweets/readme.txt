# Downloading of Tweets containing #metoo from 1 Jan 2018 to 6 Nov 2018 

##  GetOldTweets-python

    * I use the GetOldTweets-python from Jefferson-Henrique at https://github.com/Jefferson-Henrique/GetOldTweets-python.

    * I had issues getting username field to show up, turns out this issue was resolved at https://github.com/Jefferson-Henrique/GetOldTweets-python/issues/68

    * I changed line 38 of \GetOldTweets-python\got3\manager\TweetManager.py from 

    * usernameTweet = tweetPQ("span.username.js-action-profile-name b").text(); to
    
    * usernameTweet = tweetPQ("span.username.u-dir b").text();
 
    * For the python 2 compatible code, this occurs at line 41.

Dependencies:
    * https://github.com/Jefferson-Henrique/GetOldTweets-python
