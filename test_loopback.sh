#!/bin/bash

# Loopback test
# Simply take a ice, send to AoiP, take AoiP, send to ice
# Meant to check if it "works"

cd /home/tehiku/srt-streamer/
source .env
SEND_ADDR=$(python3 calc_ip.py 17011)
sed "s/SOURCE_IP/$SEND_ADDR/" source.sdp > /tmp/test_loopback.sdp
ICE_MNT=test_loopback

ffmpeg \
    -loglevel debug \
    -re \
    -protocol_whitelist file,rtp,udp,https,tls,tcp,http \
    -i http://icecast.iwi.radio:8000/Tahu_FM.aac \
    -vn \
    -acodec pcm_s24be -ar 48000 -ac 2 \
    -f rtp \
    -payload_type 96 \
    rtp://$SEND_ADDR:5004 \
&

ffmpeg \
    -loglevel debug \
    -protocol_whitelist file,rtp,udp \
    -i /tmp/test_loopback.sdp \
    -max_delay 500 \
    -c:a libvorbis \
    -b:a 96K \
    -content_type 'audio/ogg' \
    -vn \
    -f opus \
    icecast://$ICE_USER:$ICE_PASS@$ICE_URL:$ICE_PORT/$ICE_MNT \

&& fg
