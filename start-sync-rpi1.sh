#!/bin/sh

# crontab -e
# @reboot /home/pi/freechains/bin/start-sync-rpi1.sh

BIN=/usr/local/bin
HOST=RPI1
URL="https://www.duckdns.org/update?domains=francisco-santanna&token=846e3b19-bf23-4506-b482-a8f4ce5b0a52&ip="
DATA=/home/pi/freechains/data/
PEERS="192.168.1.4 192.168.1.5 lcc-uerj.duckdns.org"
CHAINS="# #br @A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431"

sleep 60

$BIN/freechains-host stop
sleep 1
$BIN/freechains-host start $DATA &
sleep 5

$BIN/freechains chains join '#'   'A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431'
$BIN/freechains chains join '#br' 'A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431'
$BIN/freechains chains join '@A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431'

mail()
{
    FILE=/tmp/mail.tmp

    while :
    do
        echo "To: freechains.logs@gmail.com"    >  $FILE
        echo "From: freechains.logs@gmail.com"  >> $FILE
        echo "Subject: [freechains] $HOST"      >> $FILE
        echo                                    >> $FILE
        echo "$HOST"                            >> $FILE

        for chain in $CHAINS
        do
            echo $chain
            echo "-----------------------"      >> $FILE
            echo $chain                         >> $FILE
            $BIN/freechains chain $chain heads  >> $FILE
        done

        # SSMTP: /etc/ssmtp/ssmtp.conf
        #root=freechains.logs@gmail.com
        #mailhub=smtp.gmail.com:465
        #FromLineOverride=YES
        #AuthUser=freechains.logs@gmail.com
        #AuthPass=<...>
        #UseTLS=YES
        /usr/sbin/ssmtp freechains.logs@gmail.com < $FILE
        rm $FILE
        sleep 12h
    done
}

sync () {
    while :
    do
        # duckdns
        echo url=$URL | curl -k -o duck.log -K -

        # sync
        for chain in $CHAINS
        do
            for peer in $PEERS
            do
                echo "$peer $chain"
                $BIN/freechains peer "$peer" send "$chain"
                $BIN/freechains peer "$peer" recv "$chain"
            done
        done

        # sleep
        sleep 10m
    done
}

mail &
sync &
wait
