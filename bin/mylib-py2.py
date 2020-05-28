#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import itertools
import os
import re
import socket
import string
import struct
import subprocess
import telnetlib
import time


def bash(cmd, cmd_input=None, timeout=None, return_stderr=False):
    """Execute cmd and return stdout and stderr in a tuple
    @cmd: the command to execute
    @cmd_input: input to give to the command
    @timeout: timeout for the command
    @return_stderr: true/false return stderr
    """
    p = subprocess.Popen(['/bin/bash', '-c', cmd],
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    if timeout is None:
        o, e = p.communicate(cmd_input)
    else:
        t = time.time()
        while time.time() - t < timeout:
            time.sleep(0.01)
            if p.poll() is not None:
                break
        if p.returncode is None:
            p.kill()
        o, e = p.communicate()
    if return_stderr:
        return o, e
    return o


def p(v, fmt="<I"):
    return struct.pack(fmt, v)


def pack(v, fmt="<I"):
    return p(v, fmt)


def u(v, fmt="<I"):
    return struct.unpack(fmt, v)


def u1(v, fmt="<I"):
    return struct.unpack(fmt, v)[0]


def u32_all(*args):
    return struct.pack("<I"*len(args), *args)


def u64_all(*args):
    return struct.pack("<Q"*len(args), *args)


def readuntil(f, delim=': '):
    data = ''
    while not data.endswith(delim):
        c = f.read(1)
        assert len(c) > 0
        data += c
    return data


def shell(s):
    """Make a socket interactive"""
    t = telnetlib.Telnet()
    t.sock = s
    t.interact()
    return


def remote(HOST, PORT):
    """Create a socket and convert it to a file buffer
    Return: socket fd
    """
    s = socket.create_connection((HOST, PORT))
    f = s.makefile('rw', bufsize=0)
    return f


def rol(val, places):
    """Rotate val left by n places"""
    shift = places % 32
    val = (val << shift) + (val >> (32-shift))
    val &= 0xFFFFFFFF
    return val


def ror(val, places):
    """Rotate val right by n places"""
    shift = places % 32
    val = (val >> shift) + (val << (32-shift))
    val &= 0xFFFFFFFF
    return val


def tmpfile(pref="lalib-"):
    """Create and return a temporary file with custom prefix"""
    import tempfile
    return tempfile.NamedTemporaryFile(prefix=pref)


def is_printable(text, printables=""):
    """Check if a string is printable"""
    return (set(str(text)) - set(string.printable + printables) == set())


def to_hexstr(str):
    """Convert a string to hex escape represent"""
    return "".join(["\\x%02x" % ord(i) for i in str])


def to_hex(num):
    """Convert a number to hex format"""
    if num < 0:
        return "-0x%x" % (-num)
    else:
        return "0x%x" % num


def int_tohex(val, nbits=64):
    """Convert signed integers to hex
    @val: integer value to convert
    @nbits: 32/64 bits (default 64)

    Example:
    >>> int_tohex(-199703103, 64)
        '0xfffffffff418c5c1'

    >>> int_tohex(-199703103, 32)
        '0xf418c5c1'
    """
    return hex((val + (1 << nbits)) % (1 << nbits))


def to_address(num):
    """Convert a number to address format in hex"""
    if num < 0:
        return to_hex(num)
    if num > 0xffffffff:  # 64 bit
        return "0x%016x" % num
    else:
        return "0x%08x" % num


def to_int(val):
    """Convert a string to int number"""
    try:
        return int(str(val), 0)
    except:
        return None


def str2hex(str):
    """Convert a string to hex encoded format"""
    result = str.encode('hex')
    return result


def hex2str(hexnum):
    """Convert a number in hex format to string"""
    if not isinstance(hexnum, str):
        hexnum = to_hex(hexnum)
    s = hexnum[2:]
    if len(s) % 2 != 0:
        s = "0" + s
    result = s.decode('hex')[::-1]
    return result


def str2intlist(data, intsize=4):
    """Convert a string to list of int"""
    result = []
    data = data.decode('string_escape')[::-1]
    l = len(data)
    data = ("\x00" * (intsize - l % intsize) +
            data) if l % intsize != 0 else data
    for i in range(0, l, intsize):
        if intsize == 8:
            val = struct.unpack(">Q", data[i:i + intsize])[0]
        else:
            val = struct.unpack(">L", data[i:i + intsize])[0]
        result = [val] + result
    return result


def hex2ascii(h):
    """Convert hexadecimal to printable ascii
    Usage:
        print convert_hex_to_ascii(0x6e69622f)
    """
    chars_in_reverse = []
    while h != 0x0:
        chars_in_reverse.append(chr(h & 0xFF))
        h = h >> 8
    chars_in_reverse.reverse()
    return ''.join(chars_in_reverse)


def bitstr(n, width=None):
    """Return the binary representation of n as a string and optionally
    zero-fill (pad) it to a given length
    ex:
        >>> bitstr(123)
        >>> '1111011'
    """
    result = list()
    while n:
        result.append(str(n % 2))
        n = int(n / 2)
    if (width is not None) and len(result) < width:
        result.extend(['0'] * (width - len(result)))
    result.reverse()
    return ''.join(result)


def hexdump(src, length=16, sep='.'):
    """@brief Return {src} in hex dump.
    @param[in] length   {Int} Nb Bytes by row.
    @param[in] sep      {Char} For the text part, {sep} will be used for non ASCII char.
    @return {Str} The hexdump
    @note Full support for python2 and python3 !
    """
    result = []
    # Python3 support
    try:
        xrange(0, 1)
    except NameError:
        xrange = range
    for i in xrange(0, len(src), length):
        subSrc = src[i:i+length]
        hexa = ''
        isMiddle = False

        for h in xrange(0,len(subSrc)):
            if h == length/2:
                hexa += ' '
            h = subSrc[h]
            if not isinstance(h, int):
                h = ord(h)
            h = hex(h).replace('0x', '')
            if len(h) == 1:
                h = '0'+h
            hexa += h+' '
        hexa = hexa.strip(' ')
        text = ''
        for c in subSrc:
            if not isinstance(c, int):
                c = ord(c)
            if 0x20 <= c < 0x7F:
                text += chr(c)
            else:
                text += sep
        result.append(('%08X:  %-'+str(length*(2+1)+1)+'s  |%s|') % (i, hexa, text))
    return '\n'.join(result)


def get_interfaces(family=4):
    """Gets all (interface, IPv4) of the local system.
    :family
        - 4 => shortcut for -family inet
        - 6 => shortcut for -family inet6
        - 4 => shortcut for -family link
    """
    d = subprocess.check_output('ip -%s -o addr' % str(family), shell=True)
    ifs = re.findall(r'^\S+:\s+(\S+)\s+inet[6]?\s+([^\s/]+)', d, re.MULTILINE)
    return [i for i in ifs if i[0] != 'lo']


def read(path):
    """Open file, return content."""
    path = os.path.expanduser(os.path.expandvars(path))
    if os.path.isfile(path) and os.access(path, os.R_OK):
        with open(path) as fd:
            return fd.read()
    else:
        print("ERROR: %s is not a file or it is not readable" % path)


def write(path, data, create_dir=False):
    """Create new file or truncate existing to zero length and write data."""
    path = os.path.expanduser(os.path.expandvars(path))
    if create_dir:
        path = os.path.realpath(path)
        ds = path.split('/')
        f = ds.pop()
        p = '/'
        while True:
            try:
                d = ds.pop(0)
            except:
                break
            p = os.path.join(p, d)
            if not os.path.exists(p):
                os.mkdir(p)
    with open(path, 'w') as f:
        f.write(data)


def which(name, all=False):
    """which(name, flags = os.X_OK, all = False) -> str or str set
    Works as the system command ``which``; searches $PATH for ``name`` and
    returns a full path if found.

    If `all` is :const:`True` the set of all found locations is returned, else
    the first occurence or :const:`None` is returned.

    Args:
      `name` (str): The file to search for.
      `all` (bool):  Whether to return all locations where `name` was found.

    Returns:
      If `all` is :const:`True` the set of all locations where `name` was found,
      else the first location or :const:`None` if not found.

    Example:
      >>> which('sh')
      '/bin/sh'
    """
    import stat
    isroot = os.getuid() == 0
    out = set()
    try:
        path = os.environ['PATH']
    except KeyError:
        log.error('Environment variable $PATH is not set')

    for p in path.split(os.pathsep):
        p = os.path.join(p, name)
        if os.access(p, os.X_OK):
            st = os.stat(p)
            if not stat.S_ISREG(st.st_mode):
                continue
            # work around this issue: http://bugs.python.org/issue9311
            if isroot and not st.st_mode & (stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH):
                continue
            if all:
                out.add(p)
            else:
                return p
    if all:
        return out
    else:
        return None


def threaded(f, daemon=True):
    """Function decorator to use threading"""
    import threading
    import Queue

    def wrapped_f(q, *args, **kwargs):
        """this function calls the decorated function and puts the
        result in a queue"""
        ret = f(*args, **kwargs)
        q.put(ret)

    def wrap(*args, **kwargs):
        """this is the function returned from the decorator. It fires off
        wrapped_f in a new thread and returns the thread object with
        the result queue attached"""
        q = Queue.Queue()
        t = threading.Thread(target=wrapped_f, args=(q,)+args, kwargs=kwargs)
        t.setDaemon(daemon)
        t.setName(args[2])
        print("[+] Starting thread name {} daemon {}".format(t.name, t.isDaemon()))
        t.start()
        t.result_queue = q
        return t
    return wrap


def xor(data, key):
    return ''.join(chr(ord(x) ^ ord(y)) for (x,y) in zip(data, itertools.cycle(key)))


def contains_not(x, bad):
    return not any(c in bad for c in x)


def contains_only(x, good):
    return all(c in good for c in x)


def validate(data, badchars):
    """Assert that no badchar occurs in data."""
    assert(all(b not in data for b in badchars))


def flatten(nested_list):
    """Dismount a nested list in one simples list
    >>> flatten([[1,2,3], [4,5,6], [7,8,9]])
    [1, 2, 3, 4, 5, 6, 7, 8, 9]

    It works with a map too:
    >>> flatten(map(lambda x: [x], range(10)))
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    similar to:
    return [item for sublist in nested_list for item in sublist]

    :nested_list: a list object with another lists as elements
    :returns: a list object
    """
    return list(itertools.chain(*nested_list))


def fmtstr_two_by_two(addr, value, offset, main=False):
    hob = value >> 16
    lob = value & 0xffff
    if hob < lob:
        first    = hob - 8
        second   = lob - hob
        offset_1 = offset
        offset_2 = offset + 1
    else:
        first    = lob - 8
        second   = hob - lob
        offset_1 = offset + 1
        offset_2 = offset
    addr_1 = pack(addr)
    addr_2 = pack(addr + 2)
    if main is True:
        fs = "{0}{1}%{2}x%{3}$hn%{4}x%{5}$hn".format(
            "".join('\\x{:02x}'.format(ord(c)) for c in addr_2),
            "".join('\\x{:02x}'.format(ord(c)) for c in addr_1),
            first, offset_1, second, offset_2)
    else:
        fs = "{0}{1}%{2}x%{3}$hn%{4}x%{5}$hn".format(
            bytes(addr_2), bytes(addr_1),
            first, offset_1, second, offset_2)
    return fs


def fmtstr_one_by_one(addr, value, offset, main=False):
    b = [value >> 24, (value >> 16) & 0xff, (value & 0xffff) >> 8, value & 0xff]
    first = b[3] - 16
    if b[2] < b[3]:
        second = 0x100 - (b[3] - b[2])
    else:
        second = b[2] - b[3]
    if b[1] < b[2]:
        third = 0x100 - (b[2] - b[1])
    else:
        third = b[1] - b[2]
    if b[0] < b[1]:
        fourth = 0x100 - (b[1] - b[0])
    else:
        fourth = b[0] - b[1]
    fs = ""
    for i, delta in enumerate([first, second, third, fourth]):
        if delta > 0:
            fs += "%{0}x%{1}$n".format(delta, offset+i)
        else:
            fs += "%{0}$n".format(offset+i)
    if main is True:
        fs = "{0}{1}{2}{3}".format(
            "".join('\\x{:02x}'.format(ord(c)) for c in pack(addr)),
            "".join('\\x{:02x}'.format(ord(c)) for c in pack(addr+1)),
            "".join('\\x{:02x}'.format(ord(c)) for c in pack(addr+2)),
            "".join('\\x{:02x}'.format(ord(c)) for c in pack(addr+3))
        ) + fs
    else:
        fs = "{0}{1}{2}{3}".format(
            bytes(pack(addr)),
            bytes(pack(addr+1)),
            bytes(pack(addr+2)),
            bytes(pack(addr+3))
        ) + fs
    return fs

