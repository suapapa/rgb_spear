#!/usr/bin/python
# -*- coding: utf-8 -*-
 
# test.py - description
#
# Copyright (C) 2011 Homin Lee <ff4500@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

import serial
import time
import random

if __name__ == '__main__':
    ser = serial.Serial('/dev/ttyUSB0', 9600)
    time.sleep(10)
    while(1):
        r = random.randint(0, 255)
        b = random.randint(0, 255)
        g = random.randint(0, 255)
        ser.write("#%02x%02x%02x"%(r, g, b))
        print("#%02x%02x%02x"%(r, g, b))
        time.sleep(5)

# vim: et sw=4 fenc=utf-8:

