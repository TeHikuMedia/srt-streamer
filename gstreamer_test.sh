#/usr/bin/bash

cd /home/tehiku/srt-streamer/

source .env
MULTICAST_IP_ADDR=$(python3 calc_ip.py $AXIA_PORT)
AUDIO_UDP_PORT=5004

gst-launch-1.0 -e --gst-debug-level=2 udpsrc address=$MULTICAST_IP_ADDR port=$AUDIO_UDP_PORT  multicast-iface=eno2 \
caps="application/x-rtp, media=(string)audio, clock-rate=(int)48000, encoding-name=(string)L24, \
encoding-params=(string)1, payload=(int)96, channels=(int)2" \
! rtpL24depay ! audioconvert ! vorbisenc ! oggmux \
! shout2send mount=/$ICE_MOUNT port=$ICE_PORT username=$ICE_USER password=$ICE_PASS ip=$ICE_URL
