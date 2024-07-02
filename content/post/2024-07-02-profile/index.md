+++
date = "2024-07-02T14:57:43-05:00"
description = ""
draft = false
tags = ["programming", "profiling", "perl", "shell", "moores-law"]
title = "Profile and be lazy"
topics = []
+++

One of the unfortunate side effects of Moore's Law is that the immense amounts of computing power at our fingertips masks over many horribly inefficient practices.  For example, something I have commonly done for a very long time is use a sort, uniq, sort pipeline to tally up something; say you have a CSV containing users and the 2nd column is the country, so you want a quick list of how many you have from each country:

```
$ cat u | awk -F, '{print $2}' | sort | uniq -c | sort -n
      1 ca
      1 mx
     14 in
     16 us
```

Obviously for a short list that first sort is not expensive at all, but with my current laptop, I can do the same thing on a file with 2 million records and it finishes in 5 seconds, despite the massive sort.  Obviously, this could be done using a O(n) algorithm like so (you could do this with Awk, of course, but I'm more fluent in Perl):

```
$ cat u | perl -ne '$a = (split(/,/))[1]; $c{$a}++; END { foreach my $i (sort {$c{$a}<=>$c{$b} } keys %c) { printf "%10d %s\n", $c{$i}, $i; } }'
      1 ca
      1 mx
     14 in
     16 us
```

(For those who have been through a job interview with me will recognize this question... few of you got it right)

Here's a different example:  When I was in high school the student government ran an annual fundraiser by doing a "computer dating" event:  everyone would fill out a short multiple choice survey, and those would be sent off to some company to generate reports matching people.

One day, the computer teacher obliquely asked me if I could write a program that could take a list of people and randomly put together lists and generate reports.  I knew what he was hinting at: let's skip hiring the company and generate fake reports ourselves.  I wrote that code, but, being a curious sort (and not entirely comfortable with the deception), I decided to try doing it the "right" way.  The basic algorithm is simply to take a string of responses and match it against everyone else in the list, take the top ten matches and generate a report.  Simple, right?

I worked on that program through the summer (keep in mind I was 16 writing in BASIC), but I got it working.  When we finally ran it on the full data set (a few hundred surveys), it sat and ran for over a week on an Apple ][ computer.  [A personal note:  since I was nursing this through, I saw every report slowly trickling out;  my name came up on exactly one of those reports, and at number 7, at that.  I was disappointed but not surprised.]  We all know the same thing would, nowadays, be a few dozen lines of code and would run in seconds, despite being an O(n^2) algorithm.

So, this leads to the current problem.  I was generating a report and I noticed that it was taking several minutes to run.  That wasn't a big deal, but my curiosity got the best of me, so I broke out a [profiler](https://metacpan.org/pod/Devel::NYTProf) and found this:

{{< img src="nytprof-before.png" >}}

Holy cow!  It makes sense as the source file has almost two million records, and I am parsing the date on every record.  Who would have thought simple date parsing could take up so much time?  I don't know what I can do to make date parsing more efficient, but I did realize that I only need the date in some limited cases, so I changed the code to only do the date parsing at the time I actually need to compare timestamps.  The result:

{{< img src="nytprof-after.png" >}}

Instead of parsing 1.8 million date entries, I now only parsed 82k.

Now, in my case, my code will never have to scale much beyond the current dataset, but if I did, there would be a catastrophe waiting to happen here.

The moral of the story is that we should all think about these seemingly minor decisions we make and think about what happens when the dataset scales up by orders of magnitude.  That expensive sort or needless date parsing could hurt someday.  Think about how your code will scale.  Profile your code!  You may discover things you didn't expect.
