#!/usr/bin/python
import sys
import os
import platform
import ipaddress

BASE_AXIA_IP = 0xEFC00000  # 239.192.0.0 [in hex]

if len(sys.argv) != 2:
    print("Please supply a valid Livewire channel number (1 - 32767). Correct usage: xplay 32767")
    sys.exit(1)
else:
    # Axia channel number + base IP (239.192.0.0 [in hex])
    MULTI_CAST_ADDRESS = ipaddress.ip_address(
        int(sys.argv[1]) +
        BASE_AXIA_IP
    ).__str__()

    print(MULTI_CAST_ADDRESS)
