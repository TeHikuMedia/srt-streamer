#!/usr/bin/python
import sys
import os
import socket

AXIA_IP = '10.2.160.0'
BASE_IP = socket.inet_aton(AXIA_IP)

RTPDUMP_BIN = 'rtpdump'
PLAY_BIN = 'play'

if len(sys.argv) != 2:
    print("Please supply a valid Livewire channel number (1 - 32767). Correct usage: xplay 32767")
    sys.exit(1)
else:
    # Axia channel number + base IP (239.192.0.0 [in hex])
    multicastAddr = int(sys.argv[1]) + eval('0x' + BASE_IP.hex())  # 0x0a02a000

    os.system(RTPDUMP_BIN + " -F payload " + hex(multicastAddr) + "/5004 | " +
              PLAY_BIN + " -c 2 -r 48000 -b 24 -e signed-integer  -B -t raw -")
