#/usr/bin/bash
# This example takes a axia channel from rdp and streams to icecast

# Need to add multicast support
#iptables -I INPUT -d 224.0.0.0/4 -j ACCEPT
#iptables -I FORWARD -d 224.0.0.0/4 -j ACCEPT

cd /home/tehiku/srt-streamer/

source .env
SOURCE_IP=$(python3 calc_ip.py $AXIA_PORT)
sed "s/SOURCE_IP/$SOURCE_IP/" source.sdp > /tmp/stream_to_ice.sdp

ffmpeg \
    -loglevel debug \
    -protocol_whitelist file,rtp,udp \
    -i /tmp/stream_to_ice.sdp \
    -max_delay 500 \
    -c:a aac \
    -b:a 96K \
    -content_type 'audio/aac' \
    -vn \
    -f mp4 \
    icecast://$ICE_USER:$ICE_PASS@$ICE_URL:$ICE_PORT/$ICE_MNT
