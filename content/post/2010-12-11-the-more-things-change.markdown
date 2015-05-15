---
author: trent
comments: true
date: 2010-12-11 13:33:44+00:00
layout: post
slug: the-more-things-change
title: The more things change...
wordpress_id: 228
categories:
- programming
tags:
- email
- error
- mail
- threading
---

Back in 1992 or so I was writing an email-based trouble-ticket system which tried to match up incoming emails to existing trouble-tickets by looking at the In-Reply-To: email header.  Much to my chagrin, I found that a few email programs did not add this header when replying to messages.  So I had to add a set of kludges to hook together tasks that were mistakenly broken by such email messages, and some subject-line shenanigans to allow tasks to be manually specified.

Well, in those days, email was a new thing, and so some amount of ignorance was understandable.  20 years later, we have managed to add those couple of lines of code into every email program, right?  Such hope is misplaced.  While wrestling to get threading to work properly in Thunderbird, I find that it is [still a problem](https://wiki.mozilla.org/MailNews:Message_Threading#E-mail_Threading_Primer)!  Viz, "The bad news is that not all e-mail clients actually generate these message headers."  Now we aren't talking about some ancient text-based email programs (ironically, they _all_ got it right back in 1992, it was the _Mac_ which was broken), the example given in the next sentence is Yahoo!

While, I know, first hand, about dealing with these sort of broken email threads, it is sad that Thunderbird cannot get it right;  none of the semi-hidden settings allow it to join together the multitude of broken email threads in my inbox.

The key to working with computers, it seems, is lowering your expectations.
