#!/usr/bin/python
# -*- coding: utf-8 -*-
 
# spear_cpu.py - description
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
UDSPath = os.path.join(os.environ["HOME"], ".rgb_spear")

def scale(v, o_min = 0, o_max = 100, t_min = 0, t_max = 255):
    if v < o_min: v = o_min
    if v > o_max: v = o_max

    s_v = ((v - o_min) * (t_max - t_min)) / (o_max - o_min)
    s_v += t_min

    return s_v

if __name__ == '__main__':
    import sys
    import statgrab

    if len(sys.argv) != 2:
        print("usage: %s <colorcode>"%sys.argv[0])
        exit(1)

    maxColor = int(sys.argv[1], 16)
    maxR = (maxColor & 0xff0000) >> 16
    maxG = (maxColor & 0x00ff00) >> 8
    maxB = (maxColor & 0x0000ff) >> 0

    while(True):
        cpuLoad = 100 - statgrab.sg_get_cpu_percents()['idle']
        r = scale(cpuLoad, 0, 100, 0, maxR)
        g = scale(cpuLoad, 0, 100, 0, maxG)
        b = scale(cpuLoad, 0, 100, 0, maxB)

        packet = "#%02x%02x%02x"%(r, g, b)
        
        n = sock.sendto(packet, UDSPath)
        if (n != len(packet)):
           print("somthing wrong!")
           exit(1)
        print("cpu = %d spear = %s"%(cpuLoad, packet))
        time.sleep(1)

    exit(0)

# vim: et sw=4 fenc=utf-8:
