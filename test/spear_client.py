#!/usr/bin/python
# -*- coding: utf-8 -*-
 
# uds_client.py - description
#
# Copyright (C) 2011 Homin Lee <ff4500@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

#!/usr/bin/python

import socket
import random
import time
import os

sock = socket.socket(socket.AF_UNIX,socket.SOCK_DGRAM)
UDSPath = os.path.join(os.environ["HOME"], ".rgb_spear")
"""
while(1):
    try:
        r = random.randint(0, 255)
        b = random.randint(0, 255)
        g = random.randint(0, 255)
        packet = "#%02x%02x%02x"%(r, g, b)
        sock.sendto(packet, UDSPath)
        time.sleep(5)
    except:
        break
"""
if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("usage: %s <colorcode>"%sys.argv[0])
        exit(1)
    packet = "#"+sys.argv[1]
    n = sock.sendto(packet, UDSPath)
    if (n != len(packet)):
       print("somthing wrong!")
       exit(1)

# vim: et sw=4 fenc=utf-8:

