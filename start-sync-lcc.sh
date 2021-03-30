#!/bin/sh

HOST=LCC
URL="https://www.duckdns.org/update?domains=lcc-uerj&token=846e3b19-bf23-4506-b482-a8f4ce5b0a52&ip="
DATA=/home/francisco/freechains/data/
PEERS="francisco-santanna.duckdns.org"
CHAINS="# #br @A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431"

freechains-host stop
sleep 1
freechains-host start $DATA &
sleep 1

freechains chains join '#'   'A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431'
freechains chains join '#br' 'A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431'
freechains chains join '@A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431'

mail()
{
    FILE=/tmp/mail.tmp

    while :
    do
        echo "To: contasospam@gmail.com"        >  $FILE
        echo "From: contasospam@gmail.com"      >> $FILE
        echo "Subject: [freechains] $HOST"      >> $FILE
        echo                                    >> $FILE
        echo "$HOST"                            >> $FILE

        for chain in $CHAINS
        do
            echo $chain
            echo "-----------------------"      >> $FILE
            echo $chain                         >> $FILE
            freechains chain $chain heads       >> $FILE
        done

        ssmtp contasospam@gmail.com < $FILE
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
                freechains peer "$peer" send "$chain"
                freechains peer "$peer" recv "$chain"
            done
        done

        # sleep
        sleep 10m
    done
}

mail &
sync &
wait
