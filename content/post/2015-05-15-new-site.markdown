+++
Categories = ["programming"]
Description = ""
Tags = ["web", "hugo", "wordpress", "golang", "html"]
date = "2015-05-15T12:09:56-04:00"
title = "The Vegan Militia 3.0"

+++

Welcome to my reworked blog.  This will mark the third incarnation
of this blog. There was a short-lived Drupal based site, then I set up
Wordpress 6 years ago.

So what's that you say?  It sounded like you said "so what", but I
know you really meant "how come?"

About a month ago I get an email from the good people at
[Laughing Squid](https://laughingsquid.us/)
informed me that I had vastly
outstripped my compute cycle quota.  I thought this was rather
surprising given that few people ever read this blog, let alone
comment.  There had been a number of attempts by spammers to post
comments on the site, but, at worst there were only a dozen or so a
day.

My first thought was that someone had broken in and uploaded their own
PHP to use my compute cycles for their nefarious purposes (this
happened several years ago).  But several searches for such things
turned up nothing.  Unfortunately, there is no way to determine what
is consuming the compute cycles, or at least I presume so, as my
repeated questions about this went unanswered.  Furthermore the apache
logs are not provided in real-time nor is the compute cycle
accounting, so it was going to take a lot of guesswork to fix this.
Poking through the apache logs revealed that thousands of hits every
day (99% of my traffic) was to wp-login.php.  The only logical
conclusion was that somebody was trying to break in, and, in the
process, caused wp-login.php to consume a lot of compute cycles
encrypting bogus passwords.  I tried a plugin to block repeated
attempts, but didn't help all that much (it reduced compute cycles by 50% where my goal was 99%).  So, I tried the brute-force
method, I renamed the login script so that all such attempts would be
immediately refused.  Viola!  Everything went back to normal.

Now all of this started to make me think: why am I bothering with
Wordpress?  What does it give me?  It lets me edit upcoming posts from
anywhere on the internet (though I have rarely taken advantage of
that).  It lets people comment on my posts (the number of times that
has happened can be counted on one hand).  But the downside is that I
now have to monitor the version of Wordpress and keep updating it to
keep up with security fixes (failing to do that several years back
earned me a break-in).  I have to monitor the comments queue and
reject spam.  Wordpress uses up a lot of disk space, MySQL is a hassle
to maintain, and people with nefarious intent can easily create havok
by running me over my quotas.  And on top of that there are no tools
for diagnosing when this happens.

So, it wasn't worth it.  Static html doesn't use compute cycles or can
it be hacked.  I started looking into static blog generators.  I had
considered [Bloxsom](http://blosxom.sourceforge.net/) many years
earlier before settling on Wordpress.  Sadly it hasn't been updated
since then, and it seemed that it was going to take a fair bit of
programming to get it to do what I wanted.  I then looked at various
scripts to use [Org-Mode](http://orgmode.org/) files (which I use
every day at work) to publish my blog; I tried three of them, but none
of them worked: two would not compile and the third one failed later
on.  So, I had to search anew.  I turned up
[Jekyll](http://jekyllrb.com/) and [Hugo](http://gohugo.io).  I goofed
around with both, and I concluded both would require similar levels of
effort, but on the list of languages I want to learn, Go is ahead of
Ruby, so I went with Hugo.

So here we are. The site is missing a lot of things, but I'll
gradually work on adding them.  If you have any experience with Hugo
or any other advice to share, let me know.