---
author: trent
comments: true
date: 2010-12-09 20:39:46+00:00
#layout: post
#layout: post
#slug: quantity-over-quality
title: Quantity over Quality
wordpress_id: 252
categories:
- programming
tags:
- error
- java
- stack trace
---

I got this error, which definitely wins the quantity over quality prize:

    
    23:56:50,545 [main]  INFO historyLogger:84 - EXCEPTION CAUGHT: org.polarion.svnimporter.ccprovider.CCException: java.io.IOException: No space left on device
     at org.polarion.svnimporter.ccprovider.internal.CCContentRetriever.getContent(CCContentRetriever.java:94)
     at org.polarion.svnimporter.svnprovider.internal.actions.SvnAddFile.calculateLengthAndChecksum(SvnAddFile.java:104)
     at org.polarion.svnimporter.svnprovider.internal.actions.SvnAddFile.dump(SvnAddFile.java:83)
     at org.polarion.svnimporter.svnprovider.internal.SvnRevision.dump(SvnRevision.java:127)
     at org.polarion.svnimporter.svnprovider.SvnDump.dump(SvnDump.java:191)
     at org.polarion.svnimporter.main.Main.saveDump(Main.java:221)
     at org.polarion.svnimporter.main.Main.run(Main.java:91)
     at org.polarion.svnimporter.main.Main.main(Main.java:49)
    Caused by: java.io.IOException: No space left on device
     at java.io.FileOutputStream.writeBytes(Native Method)
     at java.io.FileOutputStream.write(FileOutputStream.java:260)
     at org.polarion.svnimporter.common.Util.copy(Util.java:303)
     at org.polarion.svnimporter.common.FileCache.put(FileCache.java:72)
     at org.polarion.svnimporter.common.FileCache.put(FileCache.java:87)
     at org.polarion.svnimporter.ccprovider.internal.CCContentRetriever.getContent(CCContentRetriever.java:90)
     at org.polarion.svnimporter.svnprovider.internal.actions.SvnAddFile.calculateLengthAndChecksum(SvnAddFile.java:104)
     at org.polarion.svnimporter.svnprovider.internal.actions.SvnAddFile.dump(SvnAddFile.java:83)
     at org.polarion.svnimporter.svnprovider.internal.SvnRevision.dump(SvnRevision.java:127)
     at org.polarion.svnimporter.svnprovider.SvnDump.dump(SvnDump.java:191)
     at org.polarion.svnimporter.main.Main.saveDump(Main.java:221)
     at org.polarion.svnimporter.main.Main.run(Main.java:91)
     at org.polarion.svnimporter.main.Main.main(Main.java:49)
    


So, after that deluge of "information", all I know that I ran out of space on a filesystem.  Which filesystem, you ask?  If they told us that would ruin the fun of this guessing game!

The stack trace is a nice touch, since it provides little useful information, like what parameters were being passed, etc.  I used to display stack traces like this for my own programs, but have stopped doing so as they didn't provide as much information as a well-written error message.   This stack trace is much like driving directions which consist solely of the phrases "turn right" and "turn left", but no street names, distances or landmarks.  Largely useless.
