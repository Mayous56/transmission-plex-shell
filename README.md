# Shell script for combining tranmission and plex

INFO :
The script is usefull if you needto separate your download folder from your data folder (seeding torrent from a raid partition is
not recommended).

REQUIREMENT :
You should run plex and transmission on your debian server.

SETTINGS :
AUTH="TransmissionUsername:TransmissionUserPassword"
PLEXUSER="PlexUsername"
DOWNLOADDIR="TransmissionDownloadDir"
FINISHEDDIR="TransmissionFinishedDir"
MEDIADIR="PlexMediaDir"
MAXRATIO=3

HOW IT WORKS :
After setting your inforamtions, the script will check all your current torrent.
It will copy your files into the FINISHEDDIR when the torrent is downladed.
It will also make a copy of it into your plex folder.
The current path (for instance, /home/torrent/download/movie/new) will be also copy into plex folder.


