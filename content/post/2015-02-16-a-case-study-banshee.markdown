---
author: trent
comments: true
date: 2015-02-16 04:57:24+00:00
#layout: post
#layout: post
#slug: a-case-study-banshee
title: 'A Case Study: Banshee'
wordpress_id: 472
categories:
- programming
tags:
- '404'
- banshee
- error
- errors
- linux
- warning
---

For many years I was forced to use Windows on my work computers.  I almost always listen to music as I work, so I needed a music player.  I quickly grew dissatisfied with Windows Media Player, and after some searching I found [Foobar2000](http://www.foobar2000.org/), which I really liked.  A utilitarian, but capable, interface which did most everything I needed and did it pretty well.

A few years ago I switched my desktop machine to Linux.  Hurrah!  But now the music player again became an issue.  I tried Rhythmbox, Banshee and Amarok.  None of them were very good.  Nothing close to Foobar2000.  All seemed to suffer from the same issues:  lots of pointless graphical flourish, confusing and/or dumbed down interfaces, poor functionality, and lousy error handling.  By process of elimination, I ended up with Banshee.  A grudging choice which I regret on most days.

A main source of pain is the Podcast extension.  It suffers from my usual pet peeves: no indication what, if anything, is happening and poor to non-existent error reporting.  Here's a prime example:  I hit the button to check for new podcasts.  Nothing seems to happen for a few minutes, but then some new episodes pop in.  But they don't download.  I right click on a new episode, and select download.  Nothing.   I wait.  Still nothing.  So I go digging.  After several minutes of searching I find a log file buried under my home directory, it contains this:

    
    [Warn 09:24:14.993] HttpDownloadTask The Permaculture Podcast - Honeybees with Dr. Dennis vanEngelsdorp Error: System.Net.WebException: The remote server returned an error: (404) Not Found.


So, it actually _did_ attempt to download, but didn't bother to say anything.  When that download failed, it quietly tucked the error into an obscure log file, and on top of that labeled it as "Warn".  I tend to be of the opinion that when I ask for something to be done, and it cannot be, that is an "Error", not a "Warning".  But even so, the error message doesn't mention the URL or whether it was going through a proxy, without those I still don't know why it happened.  As I recall I continued experimenting with settings until I figured out that the proxy was the issue.

I didn't become a software engineer so I could spend my days pushing upstream against issues like this.
