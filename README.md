# Shell script

Combining tranmission and plex

The script is usefull if you need to separate your download folder from your data folder (seeding torrent from a raid partition is
not recommended).

Requirements
============
You should run plex and transmission on your debian server.

Usage
=====
After setting your inforamtions, the script will check all your current torrent.
It will copy your files into the FINISHEDDIR when the torrent is downladed.
It will also make a copy of it into your plex folder.
The current path (for instance, /home/torrent/download/movie/new) will be also copy into plex folder.


Installation
============
Just set the variable at the beginning of the script

AUTH="TransmissionUsername:TransmissionUserPassword"

PLEXUSER="PlexUsername"

DOWNLOADDIR="TransmissionDownloadDir"

FINISHEDDIR="TransmissionFinishedDir"


MEDIADIR="PlexMediaDir"

MAXRATIO=3



