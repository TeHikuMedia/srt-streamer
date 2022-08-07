#!/usr/bin/python
import sys
import os
import socket
import platform
import struct


BASE_AXIA_IP = 0xEFC00000  # 239.192.0.0 [in hex]


def ipToDecimal(originalIp):
    """ Takes a standard dotted-quad IP Address and returns it as an integer """

    ipStruct = socket.inet_pton(socket.AF_INET, originalIp)
    (ipDecimal, ) = struct.unpack(">L", ipStruct)
    return ipDecimal


def decimalToIp(originalDecimal):
    """ Takes a integer-based IP Address and returns it as the standard dotted-quad format """

    ipStruct = struct.pack(">L", originalDecimal)
    return socket.inet_ntoa(ipStruct)


platform = platform.platform()
if 'windows' in platform.lower():
    print("Windows")
    RTPDUMP_BIN = 'windows\\rtpdump.exe'
    PLAY_BIN = 'windows\\rtpplay.exe'
else:
    print(platform)
    RTPDUMP_BIN = 'rtpdump'
    PLAY_BIN = 'rtpplay'


if len(sys.argv) != 2:
    print("Please supply a valid Livewire channel number (1 - 32767). Correct usage: xplay 32767")
    sys.exit(1)
else:
    # Axia channel number + base IP (239.192.0.0 [in hex])
    MULTI_CAST_ADDRESS = (
        int(sys.argv[1]) +
        BASE_AXIA_IP
    )
    print(
        RTPDUMP_BIN + " -F payload " + MULTI_CAST_ADDRESS + "/5004 | " +
        PLAY_BIN + " -c 2 -r 48000 -b 24 -e signed-integer  -B -t raw -"
    )
    os.system(
        RTPDUMP_BIN + " -F payload " + MULTI_CAST_ADDRESS + "/5004 | " +
        PLAY_BIN + " -"
    )
