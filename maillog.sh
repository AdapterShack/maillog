#!/bin/sh

if [ $# != 2 ]; then
        echo "Usage: $0 <file> <email address>"
else

        tmpdir=`mktemp -d`

        zipname=`basename $1`

        zipfile="$tmpdir/$zipname.zip"

        zip -D -9 $zipfile $1

        echo "$zipname is attached" | mailx -s "Sending: $zipname" -a $zipfile $2

        rm $zipfile

        rmdir $tmpdir
fi
