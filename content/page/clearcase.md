+++
date = "2011-02-04T01:23:45"
draft = false
tags = ["programming", "clearcase"]
title = "ClearCase Critique"
+++

NOTE: I started writing this on 22-Jul-2004, tranferred it to my personal wiki on 15-Oct-2006 and the last edit was on 4-Feb-2011 (except for an update and formatting fixes).

I have been working with ClearCase since 1994 and have become *very* familiar with its problems and shortcomings.  I am using this page to accumulate a list of what is wrong, broken, or sub-optimal with ClearCase.  This page has been written gradually over several years, often when I was in a bad mood after running into a problem.  There are a number of good features of ClearCase which are not included in this page, but that information is readily available from IBM marketing.

Update: I attended the IBM Rational User's conference in Jun 2007, and it appears that some of these problems are finally getting addressed.  Version 8.0 should be sweet.  I just hope I can hold out until mid 2009.

Another Update: It is now mid 2010 and no sign of version 8.0, and version 7.1 broke the installer such that we have yet to upgrade.  My hope was obviously misplaced.

Final Update (July 2022): A reorg at my company moved me out of the team maintaining ClearCase so I no longer touch it.

## Performance

If I had a nickel for every time someone complained to me about ClearCase performance I could have retired by now.  The network architecture of ClearCase assumes that all users will be accessing the vob server via a high-speed local LAN.  This is because most ClearCase operations require a **huge** number of round-trips between the vob server and the client.

I did some rough measurements of the packets exchanged during common operations and found that a simple "desc" operation takes over 100 round-trips, a "checkout" takes over 500 round-trips, and a "checkin" requires over 1000 round-trips.

I also did a comparison of creating a snapshot view and doing an initial checkout from SVN of an identical source tree.  Subversion took about 49 round trips, but Clearcase did 117-144.  Due to this latency difference it took 19 seconds to pull the source from Google code (through an https proxy), but it took 30 seconds to pull the source from a neighboring site over the intranet.

Clearly, even the slightest increase in latency between these hosts will mean a huge performance degradation.  According to [It's the Latency, Stupid!](http://www.stuartcheshire.org/rants/Latency.html) the theoretical minimum latency for between machines on opposite shores of the USA is 42ms, in Siebel it seems to be about 62ms... that translates to a **minimum** checkin time of 62 seconds and that does not account for any processing time on any of the involved machines.

Both albd and the lock manager are single-threaded.  This means that for a large user population you must have multiple servers in order to get reasonable performance.  **Update:** it appears that the lock manager has been fixed in ClearCase 7.0.

## Access Control

Access control is very limited.  It uses the old Unix model: user/group/other.  If you have a vob which must be restricted to the members of two different groups, you will be in trouble.  The suggestion always given by IBM is to create different regions for different user populations, but that suffers from the same multi-group issue, not to mention that a machine's region can be changed.

I implemented rudimentary access control by applying an ACL on the vob storage directory.  This prevents Windows users from mounting the vobs.  Unfortunately, since vob mounting on Unix is done by root, those ACLs are ignored.

**Update:** Version 8.0 should include ACLs!  Version 7.0.1 has a group to region mapping mechanism which is a reasonable stop-gap for CCRC until then.
 
## Dynamic Views

In one sense this is the greatest feature of ClearCase: creation of a view (a.k.a. workspace) is a *constant-time operation*, i.e. creating a view for a 1mb source tree takes the same amount of time as for a 1tb source tree.  Most source control systems require you to have a copy of every file on your local disk, which can be prohibitive for large source trees, both in terms of time and space.

But, here's the rub:  This means ClearCase lets you avoid careful segmentation/componentization of a product, instead developers can throw everything into one big source tree.  But who cares?  Since dynamic views are so cheap, it doesn't matter, right?  Wrong!  When the source tree becomes so big that snapshots are no longer possible there are big downsides:
* Dynamic views are highly succeptible to network outages and performance degradation (see performance section, above)
* Developers cannot isolate themselves from the network or work from a disconnected machine (i.e. at home)
* Many irrelevant vobs will need to be replicated (see below).
* CCRC is unusable (since the views are snapshots).  Though this may change in 8.0 as there is a rumor it may have a dynamic type view.

## Configuration Specifications

Like dynamic views, config specs are a mixed bag.  They are a powerful and incredibly flexible mechanism for specifying what versions you want to look at.  I find that understanding config specs is the central piece of knowledge you must have to effectively use ClearCase.

The problem with this is that it gives you a lot of rope.  Plenty to hang yourself, though with enough slack that you won't notice until much later (usually after a lot of damage is done).

So, people often hack their config specs, usually in an effort to avoid a merge, for example something like this:
```
 element * .../mybranch/LATEST
 element * .../otherbranch/LATEST
 element * .../anotherbranch/LATEST
 ...
```

As long as those three branches are on non-overlapping sets of files, which are based on the same code base (e.g. label) this will *usually* work fine.  But as soon as there is overlap, files must be merged.  So much for avoiding the merge.  Except now the situation is worse, now the merge must be carefully done in the right order.  If, using the example above, the file foo.c has been changed on all three branches, a merge must take place from "anotherbranch" to "otherbranch", and then a merge must take place from "otherbranch" to "mybranch".  Until that is done the source tree is out of whack.

Another reason people will modify config specs is to "fix" them.  For example a whole team is using a config spec which has a timestamp.  Someone notices that the timestamp has no timezone and is thus ambiguous.  That person "fixes" the timestamp, but now is out-of-sync with the rest of the team.  Then when that person branches a file, it may be off the wrong version.  For this reason, I always tell people that *consistency is more important than correctness*.

The other problem with config specs is that it is the sole documentation as to the relationship between a branch and the code base.

## Web Interface

The ClearCase Web interface has been included with the product for many years and is still severely limited.  One of these limitations is that **interactive** triggers will not work.  It seems like this would have simply have been a matter of making "clearprompt" understand that it is being run via the web interface and interoperate with it.  But they didn't bother with that (see the "Triggers" section for further criticism of clearprompt).  Upon testing with our extensive set of triggers (only one of which is "interactive", we find that "describe" does not work, so their documentation is dead wrong: it's not "interactive" triggers that won't work, but, indeed, triggers that call most any external clearcase command.  I know that numerous companies use triggers for policy enforcement, to throw all those out the window to use the ClearCase Web interface is absurd.

**Update:** Version 7.0.1 seems to fix this so that almost all triggers work (those that modify the source file are said not to work).  Even "clearprompt" seems to work.

It's really too bad, because had AJAX been around when this was written they could have made a fairly nice interface, I'll bet.

## Remote Client

What a fantastic idea!  Replace the clunky web interface (see above) with a small Java application which talks to the same server, and gives you decent performance even over a slow WAN connection.  Unfortunately, the idea was kind of half-baked.  There are tons of bugs, among them:
* The version tree browser does not work on some files, it just ignores many branches.
* Views often get into a "discordant" state, where you have to run a special "restore" command, often repeatedly.  In a few cases, the state could not be cleared and the view had to be abandoned.
* Creating a new branch is tricky.
* The menus are poorly thought out.
* The client checks with the server too often, for example, every time you open a directory, there is a long pause.
** I measured this using Wireshark, and in this case 21 packets were exchanged and there was a 30 second pause in the conversation waiting for a response from the server.  The entire conversation took 54 seconds.
* Server/Client compatability is unreasonably strict, a 7.0.1 client cannot work against a 7.0 server or vice-versa.

Some of these problems may be mitigated by 7.1, but it appears the server has been entirely rewritten in a way that will most hamper upgrade efforts.
* The URLs have changed entirely.
* The web server has been replaced by a mess of java and it no longer has config files, instead you have to extract the configuration from the server, edit the resulting file, and feed it back into the server.
* The installer (see below)

## Triggers

In any given version control system, a "trigger" could be run on the client or on the server.  Subversion took the latter option, ClearCase, the former.  Both approaches have their downsides, but running them on the client have several severe downsides.

The first is that security is nearly impossible in an environment where users can manipulate their workstations.  For example, many years ago, I had a trigger which simply ran "false" in order to make the operation fail.  To get around that, one clever person replaced /bin/false with /bin/true, fortunately, he forgot to put it back and this is how we caught him.  Had this person been a bit more careful, there would have been no way of knowing how his checkin got in despite the trigger.

The second downside is portability.  There are a number of platforms on which the trigger must run, and throwing Windows into the mix makes this an even greater challenge.  This leaves several options, all bad:
* Write a shell/perl/whatever version for Unix, and a bat/vbs version for windows.
* Use the version of perl shipped with ClearCase which is ancient and has no libraries.  (Update: 7.0 seems to have fixed this)
* Use a perl binary located on the network.

The first option would quickly became a nightmare of keeping duplicate scripts in sync in all but the simplest of triggers.  The third option is obviously a huge performance hit, and in a system which is already renowned for slowness, would be extremely unwise.

I took the second option, and wrote an elaborate trigger infrastructure to work around all the platform foibles and perl anachronisms.  It's about 4000 lines of perl (including perldoc).  But, even so, there are a myriad of ways in which a trigger can fail.

Now the good part of client-side triggers is that it is more scalable.  It is better to have a trigger running on each person's machine rather than have all of them running on a server.

Displaying good error messages is very difficult since the UI on Windows loses the output generated by the triggers, as does the web interface (though I think 7.x improved this).  Therefore I took to using "clearprompt", but it is very ill suited for displaying long (a.k.a. informative) messages, the text ends up wrapped in odd ways and often chopped off.  Furthermore you can't select text from it (say, for a URL).

Oh, and I discovered a serious problem many years ago.  When do a triggerable action, ClearCase searches for all applicable triggers and builds a list, during which the vob is in a semi-locked state.  If you have hundreds of triggers, this can cause all kinds of problems.  Admittedly, it was not smart to have that many triggers, and it was easily fixed.

Also, see Web Interface section above.

## MultiSite

In pre-MultiSite days, if you had development at multiple sites, someone was going to be stuck accessing a vob via a WAN, which is unacceptably slow (see performance section above).  MultiSite promised to fix that by allowing vobs to be *replicated* between sites, such that each site would have local copies of each vob.  It sounded wonderful, and my employer at the time (Informix) was lobbying hard for this product and were one of the first to deploy it.

Sadly, there was a hitch: *mastership*.  MultiSite makes a key assumption:
* **All** members of a given team are working against a **single** replica, which means they can all work on a single branch mastered at that site.

In all my years I have never seen such a situation, and over the years teams have become more widely distributed.  As such, "mastership" was troublesome for administrator, and confusing for users.

In order to mitigate this *explicit mastership* was introduced (in v3, I think).  So now mastership of a branch could be moved around on different files.  This is an improvement given the following assumption:
* All members working on a given set of files are working against a single replica.

Strike two.  There are always files that multiple teams need to modify.  Furthermore, this sort of mastership is confusing.

Next, *request mastership* was introduced, which allowed users to request mastership for a given branch or branch instance.  This seems like a good idea, but there are several problems:
* It isn't well integrated into the tool, such that your checkin fails and then you have to do the request mastership, wait and try again.
* Request mastership assumes fully-interconnected sync structure.  If you have a hub-and-spoke model, a mastership request may cause huge, redundant packets to be sent between sites that do not normally exchange packets.
* Request mastership assumes you have receipt handlers in place so that changes in mastership make it into the requesting replica quickly.
* The access control lists are cumbersome to administer if you have many vobs/replicas

Here's a different problem:  When packets are being imported each action has to be replayed.  Normally this is quick... but if the packet contains 50,000 mklabel commands, your MultiSite queues become jammed.  (See the Labeling section)

And another issue:  The entire vob database and source pools are replicated, even though it is rare for a remote site to use more than a few branches/versions.  90% of what's being replicated is of no interest to a given site.  As I understand it, Perforce has a better replication strategy where local replicas simply cache what is used locally, which would be a much smarter way of doing things.

## Branching

There is no *formal* relationship between a branch and its *base point*, that key bit of information is in the config spec.  So, given a branch name, there is no way to find out the base of the branch without asking someone.  Guessing is a sure way to run into trouble.

Now, this is actually a feature since it means that the base point can be changed, which is a great optimization of the merge process.  For example, given the following branch structure:

```
              dev -------o
               /
 main --------o----------o
              C1         C2
```

So, this means the "dev" branch was created based on the "C1" checkpoint.  Let*s assume that 100 files have been changed on the "dev" branch, but, on main 1000 files have been changed between "C1" and "C2".  If you do a merge from "C2" to the "dev" branch (which seems an intuitive way of rebasing) you will bring 1000 files into your "dev" branch.  This means that another 1000 files will need to be merged from now on.  However, if first change your config spec to base "dev" on "C2" and then do a merge from "C2", you have done the same thing except you will only merge files which have been changed on both branches (which will be 100 or less).

## Merge Tools

While the merge tools with ClearCase are some of the best I have seen,
there are several key shortcomings:
* Binary files are not dealt with in any meaningful way.  Often if there is a non-trivial merge, the version on one branch will override the other, but this is never given as an option.
* The merge tools cannot cope reasonably with different line endings, such that merges where one of the versions has incorrect line endings the merge will show most every line as changed, but no indicator that the problem is line endings.

## Labels

Labels are a *linear-time operation* (O(*n*), for CS types), that is, the time taken is proportional to the number of elements being labeled.  The fastest labeling rate I ever saw was about 25 files per second.  For small source trees this is irrelevant, but for large ones it is insanely slow (see the Dynamic View section about large source trees).  This can be mitigated to a certain degree by running the mklabel commands in parallel.

Furthermore, in a MultiSite environment, the update packets containing these mklabel commands clog things up since MultiSite replays these events at about the same pace they took to run in the first place.  This clog can be made worse by labeling in parallel as suggested above.

Of course, using timestamps in a config spec can work just as well as a label, providing the engineering managers are willing to accept such a thing.

There should be a new type of label, which is really just a config spec excerpt, which would, in turn contain a branch and timestamp.

## View Profiles

When view profiles first appeared (in v3, I think), it seemed like it might address some problems with config specs.  However after working with them for several years, they seem like more of a hindrance than a help.  First off they are not portable to Unix; what is truly astounding about this mistake is that simply using forward slashes instead of backwards slashes would have done the trick.  Though this portability is further hindered by the software's inability to handle Unix line endings.  Secondly, there is no command line interface, which means if you want your build scripts to use the same view profile that developers use, you have to cook up a wrapper to do so (my ClearCase::ConfigSpec perl module does so).  It is nice that it gives you an easy, graphical way to create branches and deliver changes from them, however, this UI is missing a key feature: rebasing!  How could such an essential feature have been forgotten?

It also astounds me that a product that specializes in version control would write the view profile mechanism so that is exceedingly hard to incorporate into a VOB.  I spent a lot of time figuring out how to check in view profiles and distribute them to all sites.

Also, the if a view is associated with a view profile mechanism, all relevant vobs should be automatically mounted when the view is started.  A great feature!  However, it doesn't work much of the time, though no errors are recorded as to why.

Another problem is that the automatically generated private branch config specs use the old, cumbersome, -mkbranch modifiers, rather than the mkbranch rule.  Furthermore, they neglected to include the "-override" modifier which would have greatly simplified how they set up the private branch config specs.

It seems to me that the view profile mechanism was written by someone who knew nothing of Windows/Unix portability, version control, the command line, recent config spec features or typical branch/merge techniques.

Of course, this all begs the question as to why they didn't simply extend the config spec mechanism to include vob lists and the like?  They extended it for snapshot views...

## Snapshot Views

As noted above, snapshot views can be slow to populate due to the number of round-trips required.  For large source trees, it can be prohibitively slow.  With some systems (like visual sourcesafe) this could be mitigated by running many updates in parallel on different directories, but, unfortunately, that is out of the question for ClearCase as the snapshot view update is single-threaded and will not permit more than one to be running at a time.

## Clearmake

When I first read about clearmake and derived objects, I thought it was of the cleverest ideas I had seen.  However, I have never been able to use it in practice.  The only way to use it is to rewrite all your makefiles using their old generic dialect of Make.

Furthermore, the disk space requirements can be rather onerous, since a single old view can cause many old derived objects to be retained.  So, to avoid an explosion of disk usage, frequent audits have to be run and users constantly pestered about old views.

## Unix Windows Interop

TBD... line endings

The region synchronizer is dumb, it doesn't understand when to use -gpath/-hpath for a vob on a NAS, and, worst of all, it is a windows-only ui, which means I had to write a custom script to do automated vob tagging.

## Scheduler

In ClearCase v4 a new "Scheduler" system was introduced, which purported to "fix" many of the problems with cron.  However, in practice it is a very cumbersome system.  The first problem is that current job status and schedule information is mashed together into one "configuration file", which makes version control of these files very tricky (it is odd for a company which specializes in version control to prevent its use).  The job numbers are problematic and redundant (why not just use a job name?).  Creating a new job is tricky as there are so many entries that you have to set up.  You cannot tell from the sched file what command will be run.  That is stored in another file **which cannot be modified via the "sched" command**!  It appears as though this is a system which expects to be manipulated via a GUI, but in the years that this system has been in existence, so such GUI has surfaced.

## Internal Version Identifiers

Most version control systems I know off (e.g. CVS, SVN, VSS, RCS, SCCS, &c.) will expand certain keywords (like $Header$) inside text files to contain information about the version of the file being looked at.  This is essential for identifying which files/versions contributed to a given version of a product.  However ClearCase has no such thing.  It is often suggested to implement this via a trigger.  The problem is that this trigger will cause any non-trivial merge to be a conflicting merge, since the same line has been modified on both branches.

Some then suggested that a type manager be set up to help with this.  This is a good idea except for one thing:  there is no mechanism for deploying type managers.  Every client needs to have the new type manager.  That's not happening with over 1000 clients.

Such a type manager should have been a stock part of ClearCase from the beginning.

## Type Managers

I brought up a big issue with type managers in the previous section.  Another problem, is that the type manager mechanism confuses two separate concepts:  How the versions are stored and how differences will be presented.

Case in point:  the "ms_word" type manager is based on "file", which will store full copies of every version.  Often, the old versions of word documents are rarely going to be used, so devoting all that disk space to them is dumb.  I could convert the element type to "binary_delta_file", but that would lose the MS Word diff magic.

## Bad Error Messages

This is not unique to ClearCase, by any means; programmers should be ashamed of the poorly written, uninformative or downright misleading error messages that have become commonplace.  Any error message should answer the usual set of questions: who? what? when? how? why?  That means it should include all relevant file names, the reason for the failure, identity information (if relevant), and, ideally, some hint as to how to fix it.

Here is a little error message "hall of shame":

* "Error Creating View":  This one started showing up in the v5 timeframe.  This error could be caused by a variety of problems: bad view share, albd down, &c.
* Any error with a filename and line number, like so:
 Internal Error detected in "../map_db.c" line 822
* "Target replica(s) up to date. No export stream generated."  Which vob?  Which replica?

## New Installer

I had high hopes for post 7.0 versions after attending the IBM Rational User's conference in Jun 2007, though their predictions of future releases was overly optimistic.  But upon getting version 7.1 I found the installer had been replaced by a new installer, which was a confusing mess.  All the initial documentation seemed to assume that all installations would be done via a UI, which seems to indicate they forgot that most people have headless servers.  The documentation on how to set up release areas and set up "silent installs" is hopelessly scattered and confusing.  It is telling that the best information I have found about this comes from outside IBM.

This is a classic case of not following the maxim "if it ain't broke, don't fix it."  The old installer may have been a bit klunky but it **worked**!  I'm betting this is the work of some clueless pointy-haired IBM executive who demanded that ClearCase be brought into conformance with other IBM products.  To what degree this effort has distracted engineers from actually improving the product has yet to be seen, since a year after 7.1 was released, my team has just now gotten an installation to work, and are nowhere near figuring out how to deploy this to production servers.

## Miscelany

* Giving the option -nma to checkout fails on non-replicated vobs.  The logical thing to do is just ignore it in that case, possibly with a warning.  Failing is dumb.
```
 cleartool: Error: Nonmastered checkouts are not permitted in unreplicated VOBs; pathname: "L:/ccperf_sdc78322svod_tfisher//cm_test_sun/somefile.cpp"
 ```
* ct desc /vobs/somevob@@ fails but ct desc /vobs/somevob/.@@ works!
* There is no way to find out the physical path of a file on windows (though ct dump seems to know)
* No API!

## Opinion

Here's my take on the state of ClearCase:  Around the time that Rational took over ClearCase (1998, I think) the core product stagnated entirely.  There were no significant bug fixes or improvements since that time.  Note that most of the problems I mention above have been like that for 10 years.  A few new things were added but they all seemed botched in that they left part of the product out, or didn't support all platforms (plenty of examples above).  When IBM took over, I had hoped that they would shake things up, and it seems that in the last year or so they have.  But I fear it may be too late.  I have seen many teams abandon ClearCase out of frustration and competitive products pop up in the mean time (e.g. Subversion), and, to be honest, I'm not entirely sad about that since I am tired of being the messenger that everybody shoots at.

