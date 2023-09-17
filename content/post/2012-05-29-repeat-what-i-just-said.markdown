---
author: trent
comments: true
date: 2012-05-29 23:20:02+00:00
#layout: post
#layout: post
#slug: repeat-what-i-just-said
title: Repeat what I just said
wordpress_id: 395
categories:
- programming
tags:
- error
- programming
- windows
---

When I was a child, my parents would often tell me to repeat what they just told me, since I usually wasn't paying attention. Now I have to do the same thing with my own daughter.  Payback time, it seems.

But this blog entry isn't about parenting, it's about error messages.

I was just writing some code and realized that an important rule when writing error messages is to repeat back what the user said.  There are many violations of this rule, the first one that comes to mind is this one from Windows:

    
    The system cannot find the path specified.


That error _may_ be comprehensible if you just typed a command, but as part of a script, it will be _entirely useless_.  Obviously, the pathname needs to be displayed (of course, we still don't know what was being done, or why).

This becomes even more important when a user specified value is modified in some way.  For example I had a command line argument which could take a list.  After breaking the list apart, I needed to validate the entries in the list.  If I found anything invalid I could have simply given the error "invalid parameter".  Useless!  Rather, I filtered out the valid values and then printed out the offending ones:  "invalid parameters: a,b,c".

Now, repeat what I just said!
