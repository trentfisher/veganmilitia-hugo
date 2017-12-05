---
author: trent
comments: true
date: 2014-05-02 14:34:19+00:00
#layout: post
#layout: post
#slug: it-takes-a-village
title: It takes a village
wordpress_id: 502
---

A few days ago I was investigating a bug (which caused Subversion to dump core) and I discovered this sentence in the commentary about a very similar bug:  "A friend of mine told me it was normal, and it was not the duty of apr_hashfunc_default to 'sanitize' the parameters it receives."

When I first saw that statement I thought "no, it takes a village to write a program".

That commentary above is now doubly hearsay, and I have no idea if this is their official stance on the bug, but it is a troubling sentiment, in any context.  Software, these days, is composed of countless layers of libraries and it is _everyone's_ responsibility to deal with unexpected inputs in some way.  Otherwise you will end up with confusing error messages which are far removed from the actual problem (which is an increasing problem as we all know).  Simply letting a segfault happen is not acceptable, if you're going to insist on crashing the calling program, then at least issue an error message first.  Do something!

I have run into many situations like this in my own code.  My strategy is always to first narrow down the problem to the lowest level, write a test case and fix the bug in the lowest level library.  Then move up the stack and write a test and fix the problem in the caller, and so on.  To fix only the highest level program just sweeps the problem under the rug, until it is rediscovered _years_ later in another program.  And I do mean years.  The statement, above, which sparked this post dates to 2007, but the code I was working with was released in 2013.

