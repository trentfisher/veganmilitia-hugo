---
author: trent
comments: true
date: 2012-04-27 14:49:58+00:00
#layout: post
#layout: post
#slug: using-perforce-perforce
title: Using Perforce, perforce
wordpress_id: 377
categories:
- programming
tags:
- error
- Perforce
---

The more I work with Perforce the more I dislike it. I just wasted over an hour of my life doing what should be a trivial action: adding a user.

At this point a parenthetical rant is needed: I don't think the administrator of an SCM system should have to do such things. User management should be an IT issue, and the project owner should be in charge of who can access their repositories. The SCM administrator should just be in charge of making sure the system is set up such that that is the case.

Since this Perforce server it at its licensed user limit, I have to first delete a user to make room. That should be a trivial operation, right?

    
    $ p4 user -f -d jdoe
    User jdoe has file(s) open on 1 client(s) and can't be deleted.


Huh? I don't care about open files! Clearly the word "force" (the -f option) is being used in some strange way. Since there isn't a "really force this damn deletion" option, I have find the open file. First look for the users "client":

    
    $ p4 clients -u jdoe
    $


There are none? Obviously we have "client" sharing going on (I'll leave that for another rant). Logically, I should be able to get a list of files this person has opened, but expecting logical behavior is, apparently, unrealistic:

    
    $ p4 opened -u jdoe
    Usage: opened [ -a -c changelist# -C client -m max ] [ files... ]
    Invalid option: -u.


That's fine, I can use grep, even though it could be imprecise.  For example, imagine that we had a person named James Ava, greping for "java" could yield countless false positives.  Nevertheless, forging ahead:

    
    $ p4 opened -a | grep jdoe
    //depot/projects/releases/Something/3.14/src/ugh.c#5 - edit default change (xtext) by jdoe@goose


Sure enough, the client "goose" is owned by a different person who is active, so I can't just delete it. Fortunately, I found [another technote](http://kb.perforce.com/article/38) saying how to do this, so I do what it says:

    
    $ p4 login jdoe
    User jdoe logged in.
    $ p4 -u jdoe -c goose -H goose.example.com revert -k //depot/projects/releases/Something/3.14/src/ugh.c
    You don't have permission for this operation.


What?! I am the _administrator_. **_Super_ user**. I have permission to do anything!  So here we get to my usual pet peeve: lousy error messages. Even if we took the error message at face value, it is unhelpful since it doesn't say what permission I need (besides "super", that is). But the error message is undoubtedly incorrect, it is more likely that the server is refusing for some unrelated reason, but, due to poor programming, that generic error message is displayed.

Of course, even if that latter command worked it begs the question, why do I have to do all this menial work?  This should all be rolled into a single command.  It could be rolled into a script if the "revert" command, above, worked correctly.

I want those two hours of my life back.  I could have used them more profitably working on [the Perforce to SVN converter](http://p42svn.tigris.org/), and using it to get people off Perforce.
