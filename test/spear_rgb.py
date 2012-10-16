#!/usr/bin/python
# -*- coding: utf-8 -*-
 
# spear_client.py - description
#
# Copyright (C) 2011 Homin Lee <ff4500@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

import socket
import random
import time
import os

sock = socket.socket(socket.AF_UNIX,socket.SOCK_DGRAM)
#UDSPath = os.path.join(os.environ["HOME"], ".rgb_spear")
UDSPath = "/tmp/rgb_spear"

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("usage: %s <colorcode>"%sys.argv[0])
        exit(1)
    packet = "$"+sys.argv[1]
    n = sock.sendto(packet, UDSPath)
    if (n != len(packet)):
       print("somthing wrong!")
       exit(1)
    print("set the spear to %s"%packet)
    exit(0)

# vim: et sw=4 fenc=utf-8:

