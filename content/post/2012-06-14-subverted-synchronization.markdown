---
author: trent
comments: false
date: 2012-06-14 03:25:03+00:00
#layout: post
#layout: post
#slug: subverted-synchronization
title: Subverted synchronization
wordpress_id: 309
categories:
- programming
tags:
- error
- subversion
---

This is a fun one from svnsync:

    
    Synchronizing repository some-replica...
    Transmitting file data ......................................!
    .......................svnsync: Error!  while replaying commit


What's even better is that a Google search reveals a number of people running into this exact error.   Sadly, few of them got replies, and those that did get replies did not get helpful replies.  Certainly no solutions.

Mashing the error message on the previous line is a nice touch as it makes it harder to spot the error message, especially when there are numerous periods (thousands, in my case).

I'm a firm believer that every program has to have the ability to enable debugging output, as that could compensate for such poor error messages.  But in this case, no luck.  Maybe the [java stack trace](http://veganmilitia.org/b/?p=252) isn't so bad after all.
