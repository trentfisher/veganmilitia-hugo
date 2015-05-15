---
author: trent
comments: true
date: 2010-11-26 12:57:33+00:00
layout: post
slug: friendly-or-insulting
title: Friendly or insulting?
wordpress_id: 182
categories:
- programming
tags:
- chrome
- error
- linux
---

There is a fine line between being user friendly and treating people like morons. It is apparent that some programmers think that users cannot be presented with meaningful details of error situations as it will scare or intimidate them.  This crosses the line and is simply insulting.  Case in point (from Google Chrome):

http://picasaweb.google.com/trent.a.fisher/Errors#5540153293131164034

Wow, that's terribly uninformative.  In this case, I am trying to debug a mod_rewrite configuration (a Sisyphean task, to be sure) and I did figure out how to dig in and see the real error message, which distills down to this:

    
    <span style="font-family: Georgia, 'Bitstream Charter', serif; color: #444444;"><span style="line-height: 22px;">404 Not Found -- The requested URL /cgi-bin/w.pl was not found on this server.</span></span>


Let's think about this from a different context, if I was getting a bug reported against my web site, which error message would I prefer to be provided?  The former would be utterly useless, and I would have to go back to the person and have them do a "view source" so I could see the _real_ error message.  It would have been trivial to include the error message from the server verbatim and there's no valid reason to exclude it, except, perhaps, to keep from scaring them :)
