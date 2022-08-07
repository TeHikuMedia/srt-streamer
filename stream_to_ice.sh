#/usr/bin/bash

# This example takes a axia channel from rdp and streams to icecast
SOURCE_IP=$(python3 calc_ip.py $AXIA_PORT)
sed -i "s/SOURCE_IP/$SOURCE_IP/" source.sdp

ffmpeg \
    -loglevel quiet \
    -protocol_whitelist file,rtp,udp \
    -i source.sdp \
    -max_delay 500 \
    -c:a libvorbis \
    -b:a 96K \
    -content_type 'audio/ogg' \
    -vn \
    -f opus \
    icecast://$ICE_USER:$ICE_PASS@$ICE_URL:$ICE_PORT/$ICE_MNT
