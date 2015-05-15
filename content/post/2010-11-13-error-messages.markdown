---
author: trent
comments: true
date: 2010-11-13 17:45:23+00:00
layout: post
slug: error-messages
title: Error messages
wordpress_id: 171
categories:
- programming
tags:
- error
- programming
- quote
- unix
---

There's an old joke told many years ago by those who didn't like Unix:


<blockquote>[Ken Thompson](http://en.wikipedia.org/wiki/Ken_Thompson) has an automobile which he helped design. Unlike most automobiles, it has neither speedometer, nor gas gauge, nor any of the numerous idiot lights which plague the modern driver. Rather, if the driver makes any mistake, a giant "?" lights up in the center of the dashboard. "The experienced driver", he says, "will usually know what's wrong."</blockquote>


I'm sure the early versions of [ed](http://en.wikipedia.org/wiki/Ed_(text_editor)) inspired this.  Though in those days, when every byte counted, a certain level of terseness was understandable.  And the software was simple enough that there were a limited number of things which could be going wrong.

But now our computers are orders of magnitude bigger and more complicated.  We have layer upon layer of drivers, libraries and applications, which nobody can understand in their entirety.  And we still have a giant "?" lighting up on our dashboard.  The combination of sloppy (or nonexistent) error handling and poor error reporting, means that we all encounter incomprehensible or meaningless out-of-context error messages on a regular basis.  Increasingly, I feel that this is the key problem with computers these days:  we expend much of our time, energy and morale to the struggle of figuring out what the latest incomprehensible error message means.

Therefore, I will be devoting some time here to cataloging terrible error messages I run into and some of the bad programming practices that lead to them.  I thought I should provide some warning (and context) before I vent my spleen.
