= FavRatio

FavRatio is intended to be two things:

1. A fav aggregator site with features other sites don't have, such as FavWeight.
1. A way to learn about the Twitter API as well as the community that uses Twitter's "favorite" feature through the use of a freely-available open source Django application.

FavRatio is different to other fav aggregators:

== Collect as many favs as possible 

When FavRatio "crawls," it's only able to collect the last 20 favs given by each person. However, it does this as often as it needs to in order to make sure that none of your favs are missed, and it won't check any more often than needed. It dynamically adjusts the interval between crawls for each person based on how often that person gives stars.

== Collect only certain tweeters' favs

FavRatio is intended to be an opt-in site. It can be configured manually to limit its crawling to a list of specific tweeters. In the future there will be an option to automatically maintain this list based on who follows a certain Twitter account and/or who has signed in to FavRatio using OAuth. This has a few consequences:

* You won't see Bieber fans dominating the FavRatio leaderboards.
* You won't see celebrities dominating the FavRatio leaderboards unless FavRatio members give enough stars to them to push them to the top.
* As an opt-in community, FavRatio isn't primarily focused on being a good place to find "undiscovered talent," but there are features such as MaxFollowers and the [http://favratio.com/underfollowed "underfollowed" leaderboard] that allow you to use it for this purpose.
* This opt-in community is open to anyone that wants to join but focused primarily on showing the best content Twitter has to offer, not necessarily the tweets that get the most stars.

== Weight favs according to the value the giver places on them

The more favs you give, the less each individual fav is worth. This assumes that a fav (star) indicates a tweet was especially funny, poignant, etc., not that it's being used as a way to promote your own account or participate in what can politely be called "starloving" or ''quid pro quo'' gaming. See FavWeight for more details.

== Minimalist design

The default theme of FavRatio draws inspiration from the late Favrd and is intended to be pleasantly minimalistic.

* Avatars of star-givers are tiny; they're large enough to recognize but not so large that they work well as "advertisements" for the favers. To extend @textism's metaphor, the "take-out menus" don't clutter up the doorway to the "restaurant," if you will.

== Many uses

Would you like to see:

* the top tweets over just the last hour? How about over the last week or month?
* the weighted leaderboard for the last month?
* tweets only by people with less than a certain number of followers ("underfollowed" people)?

One of the FavRatio goals is to expose many "views" of the data in order to allow experimentation and analysis. If you can imagine a way of looking at fav data, FavRatio probably can show it to you.

And if it can't, you can modify the code so it can.

== Open

To the extent possible and practical, every part of FavRatio is designed to be open and freely available to be shared, understood, and improved upon by the community.

* The Django source code is available at https://svn.favratio.com/favratio/trunk.
* The FavWeight algorithms are within the source code and are documented in this wiki.
* Unless otherwise specified, all FavRatio code is licensed with the [http://www.gnu.org/licenses/gpl.html GPL] version 3.