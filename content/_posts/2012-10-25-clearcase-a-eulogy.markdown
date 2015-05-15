---
author: trent
comments: true
date: 2012-10-25 03:15:16+00:00
layout: post
slug: clearcase-a-eulogy
title: ClearCase -- A Eulogy
wordpress_id: 439
categories:
- programming
tags:
- ClearCase
- subversion
---

Back in 1994 I was just a few years out of college, where I was often pushing people to use the new-fangled RCS system.  On my first day at my new job I was handed a stack of ClearCase manuals and told help get it deployed.  I was amazed.  While the system was difficult to configure, it presented some amazing features, a few of which have yet to be equaled.

The Multi-Version File System was amazing.  I could create a workspace in [constant time](http://en.wikipedia.org/wiki/Constant_time#Constant_time).  There is no system before or since (that I know of) which can claim this.  The ability to change a date in a config spec and be instantly transported to what the code looked like at that time was fantastic.   Being able to do a cd command (e.g. "cd foo.c@@") and be transported into the version tree of that file seemed utterly magical all those years ago.  The unequaled branching and merging abilities permitted heavily parallel development.  A am still in awe of these things.

Here I am 18 years later looking at an email from IBM Tech Support where I am told that I "**might** be able to get this recognized as a defect" (emphasis mine).  The problem was that I installed ClearCase and got _no errors_, but found that the installation was _broken and unusable_.  A key component, indeed _the central component_, MVFS, did not get installed.  In what universe is that not a defect?

But then I realized that this unfortunate tech support engineer and myself were arguing over a corpse.   This product is dead, Jim.  We're like the two guys in [Weekend at Bernie's](http://en.wikipedia.org/wiki/Weekend_at_Bernie%27s), propping up a corpse in an attempt to convince everyone he's still alive.

ClearCase, from day one, was hobbled by several unfortunate architectural mistakes: a chatty protocol and a deep dependence on network filesystems and the attendant maze of authentication systems.  Some people have said that the lack of database scalability was the key issue, but I think that actually could have been fixed.  Even if it was, it wouldn't change the fact that _any_ amount of [network latency](http://rescomp.stanford.edu/~cheshire/rants/Latency.html) would make ClearCase's performance exponentially worse.

There are a variety of ways these fundamental problems could have been addressed given continuous development effort.  But, I would argue that the core of ClearCase has remained unchanged for almost 15 years.  The only changes made since then have been cosmetic changes, additional bolted-on bits (UCM) or replacing functional components with broken ones (like the new installer).   This product has died of neglect.

In the last 5 years I have only brought one new team into ClearCase.  Everyone else I've been steering to Subversion.  For most teams that is all they need.
