# Copyright (c) 2011 Harrison Conlin <me@harrisony.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import feedparser
import serial
import time
def scan():
    # Taken from PySerial downloads
    """scan for available ports. return a list of tuples (num, name)"""
    available = {}
    for i in range(256):
        try:
            s = serial.Serial(i)
            available[i] = s.portstr
            s.close()   # explicit close 'cause of delayed GC in java
        except serial.SerialException:
            pass
    return available
def port_select():
    print 'Attempting auto port detection'
    ports = scan()
    ser = serial.Serial(timeout=1,baudrate=115200)
    for k,v in ports.items():
        print k,v
        ser.port = k
        ser.open()
        time.sleep(2)
        line = ser.read()
        if not line:
            ser.close()
            continue
        if ord(line) == 5:
            print "Found board at %s" % v
            ser.write(chr(6))
            ser.close()
            return k

def main():
    pnum = port_select()
    ser = serial.Serial(timeout=1, baudrate=115200) # weeeeeeeeee...
    

if __name__ == '__main__':
    main()