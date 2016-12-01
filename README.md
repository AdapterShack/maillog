# maillog
Send a file as MIME attachment from a Unix system that does not have any fancy MTA installed, not even
a common text-mode client such as MUTT installed. Uses only sendmail to send the message.

This is most useful for retrieving log files from "backend" systems.

This is based on the answer to this question: http://unix.stackexchange.com/questions/102092/mail-send-email-with-attachment-from-commandline

Usage:

maillog.sh <filename> <email address>

Obviously, it only works if there is a working sendmail on the system.
