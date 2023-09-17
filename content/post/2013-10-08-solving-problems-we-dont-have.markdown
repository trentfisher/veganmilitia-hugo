---
author: trent
comments: true
date: 2013-10-08 14:05:08+00:00
#layout: post
#layout: post
#slug: solving-problems-we-dont-have
title: Solving Problems We Don't Have
wordpress_id: 463
tags:
- diff
- Git
- Mercurial
- patch
---

After attending [Subversion & Git Live 2013 in Boston](http://www.wandisco.com/subversion-live-2013), I was thinking that I need to get this written down, and where better than a rarely updated and even more rarely read blog?

In my job, I work with numerous version control systems. When I was first exposed to Mercurial and Git, I realized they very nicely solved a problem which had plagued the free software community for years.

Several years ago, I wanted to contribute fixes to [p42svn](http://p42svn.tigris.org/), which is in a Subversion repository (though what I am about to say applies to most any pre-DVCS system). I created my workspace, and then set to work on my fix. When I was done, I could not check in, since I didn't have checkin access, and didn't expect to be granted such access since the owner of the project had no idea who I was and if I could be trusted to checkin to the repository. So, I had to do a diff and then mail that to the owner. But, now, for my next change it got trickier.  Since I only want to send the owner the changes I made since the last patch, I had to manually save a copy of what I sent last time (since I couldn't check in). At this point I could have just created my own repository, and started checking in, which would have simplified this. Fortunately, I never needed to do that as the owner kindly gave me access to the repository.

But now I started experiencing the other side of this problem. I found patches on the forum for a number of fixes. But with each patch, I had a puzzle: what version did each one base their work on? If they didn't say, I had to either ask, or work it out myself, which is quite tedious.  Once I worked that out, I would create a branch, run patch and checkin their change.  Now I have their change recorded in relation to the history of the code, and I could properly evaluate the change and merge it in. Of course, the first steps could have been entirely avoided if the change had been checked into a branch directly by the contributor. But they can't do that since I don't know who they are or if they can be trusted (sound familiar?).

The beauty of Mercurial and Git is that a potential contributor can make their changes, check them in and then "push" them to me.  Thus, preserving the relationship of their change to the rest of the code.  Of course, this is just what Github and its ilk enable.  _This is fantastic!_ All that monkeying around with diff and patch is gone!  Now I can focus on the important problems.

But, here's the rub. In the enterprise, this is not a problem we face in any way. First off, it is exceedingly rare for someone on an unrelated project to contribute a fix to my code. Even if such a thing did happen, I would know exactly who that person is. So if their 'fix' fouls up the code, contains malicious code, etc, they can be held accountable for that.

In my opinion, being able to solve the unknown contributor problem discussed above is truly _revolutionary_ and is _the most important reason for using Mercurial or Git_. But it's a problem _we don't have_ in the enterprise.
