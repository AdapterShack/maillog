# maillog
Send a file as MIME attachment from a Unix system that does not have any fancy MTA installed, not even
a common text-mode client such as MUTT installed. Uses only mailx to send the message. And if there is
no mailx installed, attempts other ways to send the mail, including raw SMTP.

The file is zipped to minimize the size of the mail.

This is most useful for retrieving log files from "backend" systems.

Usage:

maillog.sh _filename_ _email-address_

Obviously, it only works if there is a working mailx on the system.
