+++
draft = "false"
date = "2019-12-10T01:34:56-04:00"
description = ""
tags = ["programming", "errors"]
title = "Screenshot dumpster dive"
topics = []
+++

I had a whole bunch of error message screenshots saved and as I was looking through, I realized two things: first, even though there are only 2 dozen of them I don't know if I have the energy to compose witty comments about each without becoming entirely demoralized.  Secondly, I began to notice some themes.  Therefore, I am going to take all the error messages I have and roughly categorize them.  Since there is often overlap I am going to present it as a table, a sort of bingo card, indicating the categorization.

The first category I call "Sorry, not sorry": inauthentic apologies for things that the author of the error message is likely responsible for in the first place.

The next category I call "Funny, not funny": instead if giving inauthentic apologies for our screw up, we will try to distract from it with a "cute" saying ("aw, snap") or a frowny face icon.  I am not laughing, just stop.

The next category is what I call "helpfully not helpful":  the error message gives some excess, though unhelpful detail with the error message.  You still don't know what went wrong but you spent twice as long reading the verbiage.  Also useless suggestions like "try again later" or "retry" fall into this bucket.

The category "dunno" covers most of these errors:  I don't know what happened (even though I am coding an exception block), so I will just feign ignorance.  It's best when these are in passive voice, and extra credit for using "something" in the error.

The next category, which rarely comes up, is when there are clues as to what went wrong.  I myself have (unintentionally) written errors like this with code like this:

`warn "Error: unable to open file $file\n";`

Of course, if $file is blank you get:

`Error: unable to open file`

Someone with some coding experience may pick up that a filename belonged there.  Putting quotes around the file would have at least given a hint that I got an empty filename (and failed to sanitize my inputs).  Note: I never said I was blameless in this error message hall of shame.

Here we go:

  error | notsorry | notfunny | nothelp | dunno | clues
--------|----------|----------|---------|-------|-------
{{< img src="chrome_error.png" >}}                        |x|x|x|x|
{{< img src="Screenshot_2017-09-11-09-11-10.png" >}}      |x| |x| |
{{< img src="bad-tbird-err.gif" >}}                       | | |x|x|
{{< img src="banshee-podcast-err.png" >}}                 | | |x|x|
{{< img src="chrome-err.png" >}}                          | | |x| |x
{{< img src="printer-error.png" >}}                       | | | |x|
{{< img src="Screenshot_2015-04-25-08-16-53.png" >}}      | | |x|x|
{{< img src="Screenshot_2016-02-16-10-55-23-fb.png" >}}   | |x|x|x|
{{< img src="Screenshot_2016-03-17-10-03-58.png" >}}      | | |x|x|
{{< img src="Screenshot_2017-05-17-18-55-54.png" >}}      | | | |x|
{{< img src="Screenshot_2017-07-06-08-58-34_kindlephoto-162653535.jpg" >}} | | |x|x|
{{< img src="Screenshot_2017-12-06-20-26-37.png" >}}      | | | |x|
{{< img src="Screenshot_2018-07-13-07-24-39.png" >}}      | | |x|x|
{{< img src="Screenshot_2018-08-15-21-42-02.png" >}}      | | |x|x|
{{< img src="Screenshot_2019-05-27-11-36-31.png" >}}      | | |x|x|
{{< img src="Screenshot at 2017-10-05 08-46-51.png" >}}   | | |x|x|
{{< img src="Screenshot from 2015-05-11 07-37-31.png" >}} | | |x|x|
{{< img src="Screenshot from 2016-12-05 20-12-13.png" >}} | | | |x|x
{{< img src="Screenshot from 2019-08-14 09-38-38.png" >}} |x|x|x|x|
{{< img src="tbird-ldap-err.png" >}}                      | | |x|x|
{{< img src="unknown.png" >}}                             | | | |x|
{{< img src="win-update-err.png" >}}                      | | | |x|

How many of those have you seen?  Perhaps I should have a giveaway for the first person to have personally seen every single one.  I don't know what sort of prize it would be.  Maybe we could sit down and share some whiskey... I feel like I need it after looking at all those.