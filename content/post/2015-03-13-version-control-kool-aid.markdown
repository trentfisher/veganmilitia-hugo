---
author: trent
comments: true
date: 2015-03-13 05:51:35+00:00
#layout: post
#layout: post
#slug: version-control-kool-aid
title: Version Control Kool-Aid
wordpress_id: 629
categories:
- programming
tags:
- Git
- kool-aid
- subversion
- version control
---

I spotted this today in a discussion about Subversion, and a workaround for a situation which ended up corrupting the workspace:


<blockquote>Arr... the reason I'm trying to get us to switch to Git. Less of this funny business.</blockquote>


I will admit, I'm not a big fan of Git.  But my biggest problem with it is the born-again fervor of some of its fans like the one above.  I will freely admit that Git has some advantages over Subversion (but there are disadvantages as well). But to claim that workspace corruption and the attendant workarounds is something Git (or any version control system) is immune to is an indicator that someone drank too much kool-aid.

Maybe it's just me, but I've been working with computers so long that I believe that every piece of software that has ever existed (or ever will exist) has its share of "funny business".  But salesmen and evangelists could never admit such a thing.

The original issue I ran into had to do with the dysfunctional practice of checking in enormous binary files.  Every version control system is going to have issues with this, though to varying degrees.  In the course of researching the issue, I found this passage about Git:


<blockquote>**The primary reason git can't handle huge files is that it runs them through [`xdelta`](http://stackoverflow.com/a/9478566/6309)**, which generally means **it tries to load the entire contents of a file into memory at once**.  **If it didn't do this, it would have to store the entire contents of every single revision of every single file, even if you only changed a few bytes of that file.  That would be a terribly inefficient use of disk space**, and _**git is well known for its amazingly efficient repository format.**_</blockquote>


I was with him up until that last phrase.  We were having a serious technical discussion, and suddenly a salesman crashed the party!   This "amazingly efficient" repository format is largely thanks to [xdelta](http://http://en.wikipedia.org/wiki/Xdelta).  The salesman neglected to mention that xdelta is the **same** mechanism used by Subversion.  We could certainly have a serious, quantitative, technical discussion about the tradeoffs of various mechanisms for storing versioned data, or about the ways to manage those deltas.  But something tells me that the salesmen and evangelists will crash that party as well.

That last phrase could have been more accurate and less obnoxious had it been phrased "and any modern version control system worth using would not do so."
