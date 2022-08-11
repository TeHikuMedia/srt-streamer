#/usr/bin/bash

cd /home/tehiku/srt-streamer/

source .env
MULTICAST_IP_ADDR=$(python3 calc_ip.py $AXIA_PORT)
AUDIO_UDP_PORT=5004

SEND_ADDR=$(python3 calc_ip.py 18001)

echo $MULTICAST_IP_ADDR
echo $SEND_ADDR


#gst-launch-1.0 -e --gst-debug-level=2 udpsrc address=$MULTICAST_IP_ADDR port=$AUDIO_UDP_PORT \
#skip-first-bytes=78 buffer-size=0 \
#caps="application/x-rtp, media=(string)audio, clock-rate=(int)48000, encoding-name=(string)L24, \
#encoding-params=(string)1, payload=(int)96, channels=(int)2" \
#! udpsink host=$SEND_ADDR port=$AUDIO_UDP_PORT

#78


# gst-launch-1.0 udpsrc address=239.192.65.61 port=5004 ! queue ! udpsink host=239.192.66.115 port=5004
# ! audio/x-raw,rate=48000,format=S24BE,channels=2 \
# ! audioresample ! audio/x-raw, rate=48000

#win!
# gst-launch-1.0 souphttpsrc location=http://libreice.tehiku.radio:8000/tehikufm_ogg \
# ! queue \
# ! oggdemux \
# ! vorbisdec \
# ! audioconvert \
# ! volume volume=1.0 ! level \
# ! audioresample ! audio/x-raw, rate=48000 \
# ! audioconvert \
# ! queue \
# ! rtpL24pay name=pay0 pt=96 max-ptime=1000000 \
# ! udpsink host=$SEND_ADDR port=5004

gst-launch-1.0 souphttpsrc location=http://libreice.tehiku.radio:8000/tehikufm_ogg \
! queue \
! oggdemux \
! vorbisdec \
! volume volume=0.5 ! level \
! audioresample \
! audioconvert \
! capsfilter caps="audio/x-raw,rate=48000,channels=2" \
! queue2 \
! rtpL24pay name=gstreamer_linux pt=96 max-ptime=1000000 \
! udpsink host=$SEND_ADDR port=5004