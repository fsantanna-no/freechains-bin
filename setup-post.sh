#!/bin/sh

PUB=A2885F4570903EF5EBA941F3497B08EB9FA9A03B4284D9B27FF3E332BA7B6431
PVT=<KEY>

MSG1=$(cat <<EOF
Hello World!
----------------------------------------
From: Francisco Sant'Anna
Pub:  @$PUB
Host: francisco-santanna.duckdns.org, lcc-uerj.duckdns.org
EOF
)

MSG2=$(cat <<EOF
Olá Mundo!
----------------------------------------
From: Francisco Sant'Anna
Pub:  @$PUB
Host: francisco-santanna.duckdns.org, lcc-uerj.duckdns.org
EOF
)

freechains chain '#'     post inline "$MSG1" --sign=$PVT
freechains chain '#br'   post inline "$MSG2" --sign=$PVT
freechains chain "@$PUB" post inline "$MSG1" --sign=$PVT
freechains chain "@$PUB" post file chico.jpg --sign=$PVT
