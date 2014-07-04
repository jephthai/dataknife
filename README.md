dataknife
=========

This is my "swiss army knife" for data.  I find myself encountering lots of chunks of data in my daily activities, and I end up using lots of little one-liners and custom scripts.  Some awk, some ruby, etc. -- but some of these tasks are so repetitive, I really want to simplify their use.  So, without further ado, this is my "data knife".  

Installation
============

Just clone the repository as follows:

    $ git clone https://github.com/jephthai/dataknife

Then make sure that the "dataknife.rb" file is executable and link it somewhere appropriate so it will be in your path.  I name it "dk" to keep things simple.

    $ chmod +x dataknife/dataknife.rb
    $ ln -s `pwd`/dataknife/dataknife.rb ~/bin/dk

Usage
=====

All of the examples provided here assume that you have dataknife accessible in your $PATH as the command "dk".  

There are lots of plugins here, and they're growing every time I find another repetitive task.  I'll give you a breakdown of the various options in here, and this will probably grow over time.  If you have any ideas on how to improve this, let me know:

Base64
------

The `base64` plugin does Base64 encoding and decoding.  By default it will decode (this seems to be what I run into most often).  However, adding the 'e' flag will encode text.  Here is an example:

    $ echo "The quick brown fox jumps over the lazy dog" | dk base64 e
    VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZwo=
    $ echo VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZwo= | dk base64
    The quick brown fox jumps over the lazy dog
    $

Chex
----

This is a Ruby port of a color hex-dump utility that I wrote some time ago.  It turns out that colorizing the output of a hexdump is very handy, as there are very distinctive patterns in many types of files.  For example, symbol tables in libraries look very different from executable code, which is also very different from plain text.  The `chex` plugin will show you a color hexdump similar to the following for the provided input:

![Screenshot of chex mode](https://raw.githubusercontent.com/jephthai/dataknife/master/docs/chex-of-sleep_png.png)

Col
---

Column mode (the `col`) plugin will print out the numbered columns indicated in the arguments.  This is my replacement for doing something like `awk '{print $2 " " $5}'` all the time.  So much SHIFTing!  I do this so often, this really speeds things up:

    $ ls -l /bin | head -n 10 | dk col 5 9
    
    18576 [ 
    1228240 bash 
    19648 cat 
    26080 chmod 
    24848 cp 
    357984 csh 
    24496 date 
    23872 dd 
    19536 df

Colsep
------

This is similar to the above `col` mode, but this plugin is called `colsep`.  The first parameter is the separator that should divide the fields in the input.  Note that this is not the same as `awk` or `cut` -- the separator is a regular expression (so something like `'[: ]'` will interpret both colons (`:`) and spaces (` `) as field separators.  Very handy:

    $ grep root /etc/passwd | dk colsep : 1 6
    root /var/root 
    daemon /var/root 
    _cvmsroot /var/empty 

Hex
---

Hex converts the input to and from a hexadecimal representation.  Binary data works well this way, for example, if you need to transfer it to someone else:

    $ echo "The quick brown fox" | dk hex e
    54686520717569636b2062726f776e20666f780a

Decoding works as well, with the 'd' parameter:

    $ echo 54686520717569636b2062726f776e20666f780a | dk hex d
    The quick brown fox

Intersect
---------

I find myself needing to find the intersection of two files very often, where the elements in the file are found one per line.  I usually end up catting both files together, then sorting, then `uniq`ing, and awking where the count is equal to two.  *whew*.  That's a lot of work.  Now I can do this:

    $ for i in a b c; do echo $i >> a; done
    $ for i in b c d; do echo $i >> b; done
    $ dk intersect a b
    b
    c
    $

IPs
---

The `ips` plugin is very helpful in my penetration testing racket.  How often do you have some tool output or data file with lots of mixed content, but including some IP addresses?  It's no fun to parse through sometimes, because the data may not be very structured.  This plugin extracts everything that looks like an IP and prints it out ('u' is optional - it prints only the unique ones):

    $ dig @8.8.8.8 google.com ANY | dk ips u
    8.8.8.8
    74.125.227.225
    74.125.227.227
    74.125.227.228
    74.125.227.233
    74.125.227.230
    74.125.227.226
    74.125.227.238
    74.125.227.232
    74.125.227.231
    74.125.227.229
    74.125.227.224
    216.73.93.70
    216.73.93.72
    8.8.8.8
    8.8.8.8

Mean
----

This takes a list of numbers (you can mix non-numeric content in -- this will tokenize the input and select out just the numeric elements) and prints out the mean (average).  Here's the average size of files in my `/bin` directory:

    $ ls -l /bin | dk col 5 | dk mean
    157711.13513513515

Shannon
-------

Ever wonder how random something is?  Sometimes when you're looking at some unknown block of data, it can be helpful to check its entropy.  This plugin calculates the Shannon entropy of the input (assuming it's read in as bytes).  Here's the entropy of a few interesting files:

    $ dk shannon < /usr/share/dict/words
    4.327008938128565
    $ dk shannon < /etc/passwd
    5.003381667727524
    $ dk shannon < /Users/jstone/src/samba-4.1.8.tar.gz
    7.999217974852452

Tokens
------

If you want to break a file up into its constituent, space-delimited words, you can do a few things.  For example, you can set your IFS to a space (but what about tabs and newlines?).  You can do some reasonable perl or sed one-liners, but there are quirks.  Here's a nice way to do it pretty cleanly:

    $ echo "The quick brown fox" | dk tokens
    The
    quick
    brown
    fox

Unbin
-----

This removes non-printable characters from the input.  This is kind of like looking at the ASCII representation of a hexdump (the "right side").  It's kind of like a lower-level "strings" command.  The '.' argument causes non-printable characters to be printed as a period character.  Something like this (note, I added newlines to make this look a bit cleaner):

    $ dd if=/bin/ls bs=512 count=1 | dk unbin .
    1+0 records in
    1+0 records out
    512 bytes transferred in 0.000016 secs (32051995 bytes/sec)
    .......................... .........H...__PAGEZERO..........
    ................................................(...__TEXT..
    .................P...............P......................__te
    xt..........__TEXT...................3......................
    ................__stubs.........__TEXT...........D..........
    .....D..............................__stub_helper...__TEXT..
    .........F...............F..............................__co
    nst.........__TEXT...........I...............I..............
    ................__cstring.......

URL Encode
----------

The `urlencode` plugin either URL-encodes or URL-decodes the input.  This gets handy when you're working on web-related stuff and you don't necessarily want (or can't) get out Burp Suite.  

    $ echo '!@#%^&*(' | dk urlencode
    !@%23%25%5E&*(

Encrypt/Decrypt
---------------

These modes encrypt or decrypt content.  It's not the most useful ever, because it's restricted to the ciphers supported by the 'crypt' gem.  Also, I believe the only option is CBC, so if you need to decrypt some random thing you found, you'll still have to write it up yourself.  But, for a handy little one-liner:

$ echo "The quick brown fox" | dk encrypt blowfish s3cr3t | dk hex e
681db9e3550e2689eaae50de3e223d398aac40d571720a363d85c21676669f31
$ echo 681db9e3550e2689eaae50de3e223d398aac40d571720a363d85c21676669f31 \
  | dk hex d | dk decrypt blowfish s3cr3t
The quick brown fox

Note that we can make sure that this is really working with something like this:

    $ dk shannon < /usr/share/dict/words
    4.327008938128565
    $ dk encrypt blowfish s3cr3t < /usr/share/dict/words | dk shannon
    7.999929192672373

And no... it's not the fastest thing ever.  But it's somewhat handy.
