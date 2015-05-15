---
author: trent
comments: true
date: 2012-10-31 03:29:20+00:00
layout: post
slug: silent-failure
title: Silent failure
wordpress_id: 448
categories:
- programming
tags:
- ClearCase
- error
---

I often rant about lousy error messages, but it seems that a growing (and maybe more worrisome) phenomenon is silent failures.  Here's an example I just ran into with ClearCase (this is not a new bug, I first encountered it over 10 years ago):

    
    $ ct desc -l vob:. | grep MITTR
     SLC0314:C:\views\MITTR.vws [uuid 107553f5.340c4e00.bd2c.3f:52:42:42:31:7b]
     $ ct rmview -force -uuid 107553f5.340c4e00.bd2c.3f:52:42:42:31:7b
     Removed references to view "SLC0314:C:\views\MITTR.vws" from VOB "/vobs/factcheck".
     $ ct desc -l vob:. | grep MITTR
     SLC0314:C:\views\MITTR.vws [uuid 107553f5.340c4e00.bd2c.3f:52:42:42:31:7b]


What exactly is happening is unimportant, what you can see is that there was an entry in the "desc" output, then I tried to remove it, _which the output indicates happened_, but double-checking indicates nothing was done.  It_ failed_, and lied about it.

My assertion that this is a defect was ignored by IBM Tech Support.  I guess their definition of "defect" is different from the rest of us.

I could be wrong, but it seems obvious to me that this sort of failure is a classic case of someone not checking for errors, that is, leaving off the last part of something like this:

    
    rmviewuuid($uuid, $vob) or warn "Error: failed to remove view $uuid from $vob\n";


While built-in exception handling (à la java) can help, I've seen plenty of code like this (even in Java textbooks):

    
    try { vob.rmview(uuid) } catch { }


Back when I started programming, little bits of sloppiness like this weren't a big deal.  It was often not hard to see what was going wrong when a 1000 line program was running.  But when you have millions of lines of code, often spread amongst numerous libraries, in many different interlocking programs, the problems grow exponentially.  As we all experience daily.




