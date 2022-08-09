#/usr/bin/bash
# This example takes a axia channel from rdp and streams to icecast

# Need to add multicast support
#iptables -I INPUT -d 224.0.0.0/4 -j ACCEPT
#iptables -I FORWARD -d 224.0.0.0/4 -j ACCEPT
$BASE_PATH=/home/tehiku/srt-streamer
source $BASE_PATH/.env
SOURCE_IP=$(python3 calc_ip.py $AXIA_PORT)
sed -i "s/SOURCE_IP/$SOURCE_IP/" $BASE_PATH/source.sdp

ffmpeg \
    -loglevel debug \
    -protocol_whitelist file,rtp,udp \
    -i /home/tehiku/srt-streamer/source.sdp \
    -max_delay 500 \
    -c:a libvorbis \
    -b:a 96K \
    -content_type 'audio/ogg' \
    -vn \
    -f opus \
    icecast://$ICE_USER:$ICE_PASS@$ICE_URL:$ICE_PORT/$ICE_MNT
