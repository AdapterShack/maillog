#!/bin/sh

# MAY NEED TO EDIT THIS IF YOU DON'T HAVE MAILX
SMTP_HOST=localhost
SMTP_PORT=25

# UNCOMMENT IF YOU WANT TO PASSWORD THE ZIP FILE
# ZIP_ARGS=-e

v_mailpart="$(uuidgen)"

if [ $# != 2 ]; then
        echo "Usage: $0 <file> <email address>"
else



        tmpdir=`mktemp -d`

        zipname=`basename $1`

        zipfile="$tmpdir/$zipname.zip"

        zip $ZIP_ARGS -D -9 $zipfile $1


        # if they have mailx then just use it
        if which mailx
        then

                 echo "$zipname is attached" | mailx -s "Sending: $zipname" -a $zipfile $2

        else

                MAILDATA="To: $2
Subject: Sending: $zipname
Content-Type: multipart/mixed; boundary=\"$v_mailpart\"
MIME-Version: 1.0
This is a multi-part message in MIME format.
--$v_mailpart
Content-Type: text/html
Content-Disposition: inline
<html><body>$zipname.zip is attached</body></html>
--$v_mailpart
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name=$zipname.zip
Content-Disposition: attachment; filename=$zipname.zip
`base64 $zipfile`
--$v_mailpart--"

                SMTPDATA="MAIL FROM:<$USER@$HOSTNAME>
RCPT TO:<$2>
DATA
$MAILDATA
."


                # really surprising if there's no nc, but you never know
                if which nc
                then

                        echo "$SMTPDATA"|nc $SMTP_HOST $SMTP_PORT


                # save sendmail for last since if there's no mailx then
                # sendmail is probably not set up correctly even if
                # the program is present on the system
                elif which sendmail
                then

                        echo "$MAILDATA"|sendmail -t

                else

                        echo "Unable to send"

                fi

        fi

        rm $zipfile

        rmdir $tmpdir
fi
