+++
date = "2023-12-21T00:37:42-04:00"
description = ""
draft = false
tags = ["computers", "programming", "automation", "error"]
title = "Wild Goose Chase"
topics = []
+++

I used to rant on here about awful error messages, but I kind of gave up as the problem kept getting worse.  It seemed that error messages were getting less informative and error handling in code was getting worse.
([I complained about this years ago]({{<relref "2019-09-07-confluence-an-err">}}))  But here's a cautionary tale about what the cost of this sloppiness can be.

So I inherited an internal service from another team, and one day I go to deploy an update, and the service will not start.  I barely understand this thing or the language it is written in, and now I have to debug it!

At first I think the service is stuck trying to contact some external service which is gone.  But after studying the error messages I find a cyclical nature to the errors:  "starting service", "starting subsystem x", "starting subsystem y", etc., "starting service", repeating endlessly.  So it is not hanging but crashing repeatedly with no error messages.

Now I come to the horrifying realization:  If my service should go down for *any* reason, it will not start up again.  I cannot patch the OS, or do anything which would cause a restart.  If that happens, I will now have a crisis on my hands, and I don't even know what is happening.

I poked around further and discovered that the on-disk logs had one more error message.  I suppose this error did not make it out to the logging server before the service crashed.  Sounds like another bug to me.  But this error message was bewildering:  "`java.sql.SQLException: An attempt by a client to checkout a Connection has timed out.`"  That makes no sense.  First off, which database?  The service connects to several.  Secondly, the time between the previous log entry and this one is around 2 seconds; no sane person would set a timeout that short.  I found a timeout setting which was, bewilderingly, set to 1 second!  I changed it to 10 seconds.  Now the time gap in the log was 20 seconds.  I am not sure why it is off by a factor of two.  Perhaps there are two attempts to connect, or there is a straight up math error.

Clearly there is something going wrong while connecting to the database, but that makes no sense:  the database is running, and nothing has changed in any of the servers or network settings.  That I know of.  Better test it.  The MySQL command line client gets through just fine.  But maybe the library being used is at fault, so now I have to learn enough of this language to write a simple database client.  Several hours later I have some code working.  It works fine in every relevant context.  So the "timeout" is, as I thought, a *lie*.

I dig through the stack trace and it seems whatever is going wrong is happening right here:

        Connection out = driver().connect( jdbcUrl, properties );
        if (out == null)
            throw new SQLException("Apparently, jdbc URL '" + jdbcUrl + "' is not valid for the underlying " +
                            "driver [" + driver() + "].");

From the stack trace it is clear the exception is being thrown, but somewhere along the line that error message, as uninformative as it is (i.e. there is no indication of *why* it failed), is getting lost or suppressed.

Fortunately, one of the previous maintainers pointed out a way to enable more detailed logging.  Miraculously, it revealed this error message:

    java.sql.SQLException: The server time zone value 'UTC' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.

So a fatal error is happening when connecting to the database.  But that fatal error is suppressed unless debugging output is enabled.  Let's just pause and re-read the last sentence.  Furthermore, the message from the other exception shown above is getting dropped along the way.  But regardless a helpful article on [Stack Overflow](https://stackoverflow.com/questions/26515700/mysql-jdbc-driver-5-1-33-time-zone-issue) which pointed out a simple solution to add "serverTimezone=UTC" to the URL.  Problem solved!

Two great mysteries remain: What changed in order to cause the timezone disagreement?  My best guess is that an OS update changed some obscure timezone setting in such a way as to cause one of the servers to become confused about their timezone.  The other mystery is why this fatal error was only sometimes fatal, and that "sometimes" became more and more likely as time went on, so early on, the service would restart repeatedly but then come up after some number of retries, eventually this became infinite.

But regardless, this illustrates the cost of sloppy error handling and uninformative error messages.  I spent two full weeks clawing through source code trying to find the actual problem
(the whole time in a panic that my production servers might get restarted and my service would be entirely down with no way to bring it back).
But once the real error message was exposed the problem was fixed in minutes.
That's two weeks lost because someone couldn't be bothered to do proper error reporting.




