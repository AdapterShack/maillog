# maillog
Send a file as MIME attachment from a Unix system that does not have any fancy MTA installed, not even
a common text-mode client such as MUTT installed. Uses only mailx to send the message. And if there is
no mailx installed, attempts other ways to send the mail, including raw SMTP.

The file is zipped, if possible, to minimize the size of the mail.

This is most useful for retrieving log files from "backend" systems.

Usage:

  maillog.sh _filename_ _email-address_

You must either have a working "mailx" program, a working "sendmail" program, OR both a working "nc"
(netcat) and an SMTP server that will be willing relay your messages.

In order for the file to be compressed, you must have "base64" and one of "zip" or "gzip". Otherwise
the file is send uncompressed.
