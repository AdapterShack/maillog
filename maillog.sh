#!/bin/sh

# MAY NEED TO EDIT THIS IF YOU DON'T HAVE MAILX
SMTP_HOST=localhost
SMTP_PORT=25

# UNCOMMENT IF YOU WANT TO PASSWORD THE ZIP FILE
#ZIP_ARGS=-e

if which uuidgen
then
	v_mailpart="$(uuidgen)"
else
	v_mailpart=`tr -dc A-Za-z0-9 </dev/urandom | head -c 80`
fi


if [ $# != 2 ]; then
        echo "Usage: $0 <file> <email address>"
else



        tmpdir=`mktemp -d`

        zipname=`basename $1`

        zipfile="$tmpdir/$zipname.zip"

	if which zip
	then
        	zip $ZIP_ARGS -D -9 $zipfile $1
	elif which gzip
	then 	
		zipfile="$tmpdir/$zipname.gz"
		gzip -c $1 > $zipfile
	else
		echo "Can't compress"
		zipfile="$tmpdir/$zipname"
		cp $1 $zipfile
	fi

	attachname=`basename $zipfile`

        # if they have mailx then just use it
        if which mailx
        then

                 echo "$attachname is attached" | mailx -s "Sending: $zipname" -a $zipfile $2

        else


		if which base64
		then
			ATTACHDATA="Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name=$attachname
Content-Disposition: attachment; filename=$attachname
`base64 $zipfile`"
		else
			echo "Can't encode"
			attachname=$zipname
			ATTACHDATA="Content-Transfer-Encoding: 8bit
Content-Type: application/octet-stream; name=$attachname
Content-Disposition: attachment; filename=$attachname
`cat $1`"                
		fi

		MAILDATA="To: $2
Subject: Sending: $zipname
Content-Type: multipart/mixed; boundary=\"$v_mailpart\"
MIME-Version: 1.0

This is a multi-part message in MIME format.
--$v_mailpart
Content-Type: text/html
Content-Disposition: inline
<html><body>$attachname is attached</body></html>
--$v_mailpart
$ATTACHDATA
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
