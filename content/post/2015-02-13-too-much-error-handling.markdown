---
author: trent
comments: true
date: 2015-02-13 22:15:48+00:00
#layout: post
#layout: post
#slug: too-much-error-handling
title: Too much error handling?
wordpress_id: 209
categories:
- programming
tags:
- error
- programming
---

Years ago one of my co-workers complained that my code had "too much error handling".  I was astonished, but said little in defence since I was the new guy on the team.  Looking back on this, years later, I am bothered by this attitude.   It is easy to write code that works correctly when everything it depends upon works correctly.  Given the complexity of modern software and hardware, there are an endless number of things which can fail.

Therefore, error handling becomes the most critical part of the code.  We have to code with the assumption that anything can fail.  In my experience, it will, sooner or later.  When the failure does happen, it must be dealt with in a reasonable manner.  Ideally that would be some sort of self-healing, retrying in the case of transient issues, and, failing that a useful and comprehensive error message.

I first started writing this post at least 4 years ago, and in the meantime it has become apparent that my point of view is the minority amongst programmers.  Silent failures, incomprehensible error messages, and, crashes are a daily part of life amongst the recent wave of gadgetry.  But I guess the plus side is it gives me something to complain about here.
