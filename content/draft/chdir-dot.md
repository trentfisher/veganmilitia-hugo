+++
date = "2019-09-18T14:57:43-05:00"
description = ""
draft = true
tags = ["programming", "error"]
title = "With No Output"
topics = []
+++

So I create numerous SVN replicas and since it takes several steps to do this, I have it automated all the icky bits in a script.  The whole thing mysteriously fails with this:

> svn: E165001: Revprop change blocked by pre-revprop-change hook (exit code 255) with no output.

I go and run the propset command manually... works fine.  I run it through the debugger... all is well, but the propset command fails.  I run the propset command in another window... works fine.  Now, from in the debugger I run the propset with strace.  Buried in the output I find this:

> 18704 chdir(".")                        = -1 EACCES (Permission denied)
> 18704 exit_group(-1)                    = ?

Sure enough!  I had su'ed to the repository owner id, but my personal home directory was locked up:

> $ ll
> ls: cannot open directory .: Permission denied

One thing to note is that there is no attempt to issue an error message between the chdir() and the exit_group().  I wonder which would cost more: the programmer adding one line of code to issue an error message, or me spending half an hour figuring out this problem?
