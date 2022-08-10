#/usr/bin/bash

cd /home/tehiku/srt-streamer/

source .env
MULTICAST_IP_ADDR=$(python3 calc_ip.py $AXIA_PORT)
AUDIO_UDP_PORT=5004

SEND_ADDR=$(python3 calc_ip.py 17009)

echo $MULTICAST_IP_ADDR
echo $SEND_ADDR


#gst-launch-1.0 -e --gst-debug-level=2 udpsrc address=$MULTICAST_IP_ADDR port=$AUDIO_UDP_PORT \
#skip-first-bytes=78 buffer-size=0 \
#caps="application/x-rtp, media=(string)audio, clock-rate=(int)48000, encoding-name=(string)L24, \
#encoding-params=(string)1, payload=(int)96, channels=(int)2" \
#! udpsink host=$SEND_ADDR port=$AUDIO_UDP_PORT

#78


gst-launch-1.0 udpsrc address=239.192.65.61 port=5004 ! udpsink host=239.192.70.79 port=5004
