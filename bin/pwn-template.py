#!/usr/bin/env python
# -*- coding: utf8 -*-
import socket
import struct
import telnetlib


def readuntil(f, delim=': '):
    data = ''
    while not data.endswith(delim):
        c = f.read(1)
        assert len(c) > 0
        data += c
    return data

p  = lambda v, fmt="<I": struct.pack(fmt, v)
u  = lambda v, fmt="<I": struct.unpack(fmt, v)
u1 = lambda v, fmt="<I": struct.unpack(fmt, v)[0]


def shell(s):
    t = telnetlib.Telnet()
    t.sock = s
    t.interact()
    return

HOST = ""
PORT = ""

s = socket.create_connection((HOST, PORT))
f = s.makefile('rw', bufsize=0)

## exploit here
payload = ""
payload += shellcode

f.write(shellcode+"\n")

print "[+] shell is ready: "
shell(s)
