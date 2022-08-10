#/usr/bin/bash

cd /home/tehiku/srt-streamer/

source .env
MULTICAST_IP_ADDR=$(python3 calc_ip.py $AXIA_PORT)
AUDIO_UDP_PORT=5004
ICE_MNT=test_gstreamer_test_sh

gst-launch-1.0 udpsrc address=$MULTICAST_IP_ADDR port=$AUDIO_UDP_PORT \
caps="application/x-rtp, media=(string)audio, clock-rate=(int)48000, encoding-name=(string)L24, \
encoding-params=(string)1, payload=(int)96, channels=(int)2" \
! rtpL24depay \
! audioconvert \
! audio/x-raw,rate=48000,format=S16LE,channels=2,layout=interleaved \
! opusenc ! oggmux \
! shout2send mount=/$ICE_MNT port=$ICE_PORT username=$ICE_USER password=$ICE_PASS_GST ip=$ICE_URL
