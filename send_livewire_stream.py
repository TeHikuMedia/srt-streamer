#!/usr/bin/python
import sys
import os
import socket
import struct


def ipToDecimal(originalIp):
    """ Takes a standard dotted-quad IP Address and returns it as an integer """

    ipStruct = socket.inet_pton(socket.AF_INET, originalIp)
    (ipDecimal, ) = struct.unpack(">L", ipStruct)
    return ipDecimal


def decimalToIp(originalDecimal):
    """ Takes a integer-based IP Address and returns it as the standard dotted-quad format """

    ipStruct = struct.pack(">L", originalDecimal)
    return socket.inet_ntoa(ipStruct)


LOCAL_IP = '10.2.160.1'
AXIA_IP = '239.192.0.0'
# AXIA_IP = '10.2.160.1'
BASE_IP = socket.inet_aton(AXIA_IP)

AXIA_PORT = 111
AXIA_PORT = 16701

RTPDUMP_BIN = 'rtpdump'
PLAY_BIN = 'play'

INPUT_DEVICE = ['-re', "-f", "dshow", '-i',
                'audio="Livewire In 06 (AXIA IP-Driver (WDM))"']

INPUT_DEVICE = ['-re', '-i', 'https://stream.iwi.radio/Awa_FM.aac']

SEND_IP = decimalToIp(int(AXIA_PORT) + ipToDecimal(AXIA_IP))

print(f"Send to port {AXIA_PORT} => {SEND_IP}")

command = (
    ['ffmpeg'] +
    INPUT_DEVICE +
    ['-c:a', 'pcm_s24be', '-ar', '48000', '-ac',
        '2', '-f', 'rtp', f'rtp://{SEND_IP}:5004?localaddr={LOCAL_IP}']
)

print(" ".join(command))

# os.system(RTPDUMP_BIN + " -F payload " + hex(multicastAddr) + "/5004 | " +
#               PLAY_BIN + " -c 2 -r 48000 -b 24 -e signed-integer  -B -t raw -")
