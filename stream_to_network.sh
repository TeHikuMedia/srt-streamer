#/usr/bin/bash
# This example takes an icecast stream
# and sends it to axia AioP

cd $HOME/srt-streamer/

source .env
SOURCE_IP=$(python3 calc_ip.py $AXIA_PORT)
SEND_ADDR=$(python3 calc_ip.py 17011)

ffmpeg \
    -loglevel debug \
    -re \
    -protocol_whitelist file,rtp,udp,http,tcp \
    -i http://icecast.iwi.radio:8000/Te_Arawa_FM.aac \
    -vn \
    -filter:a loudnorm \
    -acodec pcm_s24be -ar 48000 -ac 2 \
    -f rtp \
    -payload_type 96 \
    rtp://$SEND_ADDR:5004

#16701
