#!/bin/sh

if [ $# != 2 ]; then
        echo "Usage: $0 <file> <email address>"
else

        tmpdir="/tmp/$(uuidgen)"

        mkdir $tmpdir

        zipfile="$tmpdir/$1.zip"

        zip -9 $zipfile $1

        echo "$1 is attached" | mailx -s "Sending: $1" -a $zipfile $2

        rm $zipfile

        rmdir $tmpdir
fi
