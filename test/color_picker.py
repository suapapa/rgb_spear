#!/usr/bin/python
# -*- coding: utf-8 -*-
 
# color.py - description
#
# Copyright (C) 2011 Homin Lee <ff4500@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

import wx
import serial


app = wx.PySimpleApp()
dialog = wx.ColourDialog(None)
dialog.GetColourData().SetChooseFull(True)
if dialog.ShowModal() == wx.ID_OK:
    data = dialog.GetColourData()
    print 'You selected: %s\n' % str(data.GetColour().Get())
    ser = serial.Serial('/dev/ttyUSB0', 9600)
    ser.write("#%02x%02x%02x" % data.GetColour().Get())
    ser.flush()
    ser.close()
dialog.Destroy()

# vim: et sw=4 fenc=utf-8:

