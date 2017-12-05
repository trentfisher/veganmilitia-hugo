---
author: trent
comments: true
date: 2015-03-27 05:16:05+00:00
#layout: post
#layout: post
#slug: funny-spam
title: Funny Spam
wordpress_id: 631
categories:
- programming
tags:
- one-liner
- perl
- spam
---

The only good thing that spammers do for us is to give us something to laugh at. The latest case was a comment in my moderation queue which started like this:

    
    {I have|I’ve} been {surfing|browsing} online more than {three|3|2|4} hours today, yet I never found any interesting article like yours.


It continued on for quite a while, but I'll spare you. Clearly someone screwed up their automation.  Just for grins, I wanted to see if I could write a one-liner to process this input, and, viola!

    
    perl -pe 's(\{(.+?)\})(@a=split(/\|/, $1); $a[rand(1+$#a)])ge' < spam


I've replaced a spammer with a one liner!  If only that meant they'd go away.
