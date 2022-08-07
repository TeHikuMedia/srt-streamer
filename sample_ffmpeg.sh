# This example takes a axia channel from rdp and streams to icecast

ICE_USER=user
ICE_PASS=pass
ICE_PORT=8000
ICE_URL=icecast.com
ICE_MNT=mount

ffmpeg \
    -protocol_whitelist file,rtp,udp \
    -i test.sdp \
    -max_delay 500 \
    -c:a libvorbis \
    -b:a 96K \
    -content_type 'audio/ogg' \
    -vn \
    -f opus \
    icecast://$ICE_USER:$ICE_PASS@$ICE_URL:$ICE_PORT/$ICE_MNT
