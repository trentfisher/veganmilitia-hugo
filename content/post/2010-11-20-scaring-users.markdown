---
author: trent
comments: true
date: 2010-11-20 16:25:33+00:00
#layout: post
#layout: post
#slug: scaring-users
title: Scaring users
wordpress_id: 150
categories:
- programming
tags:
- error
- perl
- programming
---

Some years ago I ran into a piece of code which shocked me, and in the time since then I have realized that it exemplified a lot of what is wrong with software.  Sadly, I have since lost the code, so here is an approximation:

    
    unless (open(F, "/some/important/file"))
    {
        # We don't want to scare the users with an error message
        # warn "Unable to read config file";
    }


Am I the only one who is outraged by this?  What is scarier to a user, to get an error message when a genuine error situation occurred or let the software plod on getting even stranger and more non-sensical errors which cascade from this initial problem? For example, imagine the following code further on:

    
    
    my $req = $http->request($config->{url});
    die "Unable to contact web server $config->{url}\n" unless $req;
    


The config structure was empty because it could not be read due to the earlier problem, so the error message simply says "Unable to contact web server".  So now you are led to believe that the problem is with some unspecified web server.  How much time will you waste trying to track that down?

So which is worse, "scared" or confused and frustrated?
