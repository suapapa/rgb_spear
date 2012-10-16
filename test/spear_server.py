#!/usr/bin/python
# -*- coding: utf-8 -*-
 
# spear_server.py - description
#
# Copyright (C) 2011 Homin Lee <ff4500@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

import serial
import socket
import os
import sys
import time

try:
    serialPort = sys.argv[1]
except:
    serialPort = '/dev/ttyUSB2'
    print "will open default serial port, %s"%serialPort

ser = serial.Serial(serialPort, 9600)
sock = socket.socket(socket.AF_UNIX,socket.SOCK_DGRAM)

#UDSPath = os.path.join(os.environ["HOME"], ".rgb_spear")
UDSPath = "/tmp/rgb_spear"
if os.path.exists(UDSPath):
    os.remove(UDSPath)
sock.bind(UDSPath)

print("RGB Spear server start. UDS: %s"%UDSPath)
while(1):
    try:
        packet = sock.recv(1024)
        # print packet
        if packet == "quit":
            break;
        else: #elif packet.startswith("#"):
            ser.write(packet)
            # print ".",
            # sys.stdout.flush()
        time.sleep(0.5)
    except:
        break

ser.close()    
os.unlink(UDSPath)

print("RGB Spear server finished")
# vim: et sw=4 fenc=utf-8:

