#!/bin/bash
AUTH="TransmissionUsername:TransmissionUserPassword"
PLEXUSER="PlexUsername"
DOWNLOADDIR="TransmissionDownloadDir"
FINISHEDDIR="TransmissionFinishedDir"
MEDIADIR="PlexMediaDir"
MAXRATIO=3

TORRENTLIST=`transmission-remote --auth $AUTH  -l | sed -e "1d;$d;s/^ *//" | cut -d ' ' -f 1`

for TORRENTID in $TORRENTLIST
do
        TORRENTID=`echo $TORRENTID | sed 's:*::'`
        TORRENTID=`echo $TORRENTID | sed 's:\:::'`
        if [[ $((TORRENTID)) == $TORRENTID ]];
        then

                echo "* * * * * Operations on torrent ID $TORRENTID starting. * * * * *"

                DL_COMPLETED=`transmission-remote --auth $AUTH --torrent $TORRENTID --info | grep "Percent Done: 100%"`
                DL_RATIO=`transmission-remote --auth $AUTH --torrent $TORRENTID --info | grep -n "Ratio" | awk 'NF{print $NF; exit}'`

                LOCATION=`transmission-remote --auth $AUTH --torrent $TORRENTID --info | grep -n "Location" | sed "s:^.*$DOWNLOADDIR::"`
                LOCATIONFINISHED=`transmission-remote --auth $AUTH --torrent $TORRENTID --info | grep -n "Location" | sed "s:^.*$FINISHEDDIR::"`
                NAME=`transmission-remote --auth $AUTH --torrent $TORRENTID --info | grep -n "Name" | sed "s:^.*Name\: ::"`

                if [ "$DL_RATIO" = "Inf" ] || [ "$DL_RATIO" = "None" ]
                then
                        COMPARE_RATIO=0
                else
                        COMPARE_RATIO=`echo "$DL_RATIO > $MAXRATIO" | bc`
                fi

                if [ "$DL_COMPLETED" != "" ]
                then
                        PLACE=`echo $LOCATION | grep -n "Location"`
                        if [ "$PLACE" == "" ]
                        then
                                sudo -u "$PLEXUSER" mkdir -p "$MEDIADIR$LOCATION"
                                sudo -u "$PLEXUSER" rsync -ra "$DOWNLOADDIR$LOCATION/$NAME" "$MEDIADIR$LOCATION"
                                TRANSMITTED=`transmission-remote --auth "$AUTH" --torrent "$TORRENTID" --move "$FINISHEDDIR$LOCATION"`
                                echo "Torrent #$TORRENTID : #$NAME déplacé dans media et finished"
                        elif [ "$COMPARE_RATIO" == 1 ]
                        then
                                DELETED=`transmission-remote --auth "$AUTH" --torrent "$TORRENTID" --remove-and-delete`
                                echo "Torrent #$TORRENTID : #$NAME a depasse le ratio. On supprime."
                        fi
                else
                        echo "Torrent #$TORRENTID : #$NAME n'a pas terminé son téléchargement."
                fi
        fi
done

chown -R "$PLEXUSER":"$PLEXUSER" $MEDIADIR
chmod -R 775 $MEDIADIR
