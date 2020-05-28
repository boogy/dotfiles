#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import subprocess
from random import randint

p = argparse.ArgumentParser(usage="""
Redirect stdin,stdout to a socket. Forks each connection.
Example: $ listen --port 80 -- ls -la
""")
p.add_argument('-p', '--port', help='port to listen on', default=randint(1024, 2**16-1))
p.add_argument('--tty', action='store_true', help='act like a tty (interpret backspaces)')
p.add_argument('--raw', action='store_true', help="dont interpret escape codes (e.g. '\x03' is not ctrl+c")
p.add_argument('--dump', action='store_true', help='dump raw data transferred to stderr', default=False)
p.add_argument('--stderr', action='store_true', help="send stderr over the socket")
p.add_argument('-v', '--verbose', help='detailed output, repeat for more', action='count', default=0)
p.add_argument('program', nargs=1)
p.add_argument('arguments', nargs='*')
a = p.parse_args()
# a.tty=0

prog = 'socat'
listen = 'tcp4-listen:%s,reuseaddr,fork,end-close' % a.port
execu = "exec:'%s'" % ' '.join(a.program + a.arguments)

if a.tty:
    # When running 'sh' under socat, the following messages come up
    # when any of these options are REMOVED:
    #
    # 'ctty' => "can't access tty; job control turned off"
    # 'echo=0' => All data sent to the program will be sent back over the socket
    # 'pty' => 'inappropriate ioctl for device'
    execu += ",pty,setsid,setpgid,echo=0"
if a.raw:
    # When 'raw' is not enabled, things like 'xxd' break completely, and anything that
    # sends non-ASCII data (e.g. sending \x03\x00\x00\x00 for a DWORD 3) will not behave
    # correctly.
    execu += ",raw"
if a.stderr:
    # Sometimes you need stderr over the socket too.
    execu += ',stderr'

args = [prog] + ['-v']*a.dump + ['-d']*a.verbose + [listen, execu]
print 'Executing: %s' % ' '.join(args)
print "Listening on port %s for incoming connections. Press CTRL+C to stop..." % a.port

try:
    subprocess.call(args)
except KeyboardInterrupt:
    pass
