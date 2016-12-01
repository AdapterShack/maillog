#!/bin/sh
# Credits: http://unix.stackexchange.com/questions/102092/mail-send-email-with-attachment-from-commandline
v_mailpart="$(uuidgen)"
echo "To: $2
Subject: $1
Content-Type: multipart/mixed; boundary=\"$v_mailpart\"
MIME-Version: 1.0

This is a multi-part message in MIME format.
--$v_mailpart
Content-Type: text/html
Content-Disposition: inline

<html><body>$1 is attached</body></html>

--$v_mailpart
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name=$1
Content-Disposition: attachment; filename=$1

`base64 $1`
--$v_mailpart--" | /usr/sbin/sendmail -t
