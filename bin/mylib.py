#!/usr/bin/env python3

import itertools
import os
import re
import string
import subprocess
import tempfile
import time
from base64 import b64decode, b64encode


def encode_utf(data, enc='utf-8', errors='backslashreplace'):
    """Encode a unicode string
    @data: data string to encode
    @enc: encoding to use
          default: utf-8
    @errors: error type
             possible values: [ignore|replace|strict|backslashreplace|namereplace|xmlcharrefreplace]
             default: backslashreplace
    """
    return data.encode(enc, errors)


def decode_utf(data, enc='utf-8', errors='backslashreplace'):
    """Decode a unicode string
    @data: data string to decode
    @enc: encoding to use
          default: utf-8
    @errors: error type
             possible values: [ignore|replace|strict|backslashreplace|namereplace|xmlcharrefreplace]
             default: backslashreplace
    """
    return data.decode(enc, errors)


def utf_strlen(data):
    """Return length of a UTF encoded string"""
    return len(data.encode('utf-8'))


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
        return decode_utf(o), decode_utf(e)
    return decode_utf(o)


def b64_decode(data):
    b64decode(data.encode('utf-8', errors='backslashreplace'))


def b64_encode(data):
    b64encode(data.encode('utf-8', errors='backslashreplace'))


def is_printable(text, printables=""):
    """Check if a string is printable"""
    return (set(str(text)) - set(string.printable + printables) == set())


def to_hexstr(data):
    """Convert a string to hex escape represent"""
    return "".join(["\\x%02x" % ord(i) for i in data])


def to_hex(num):
    """Convert a number to hex format"""
    if num < 0:
        return "-0x%x" % (-num)
    else:
        return "0x%x" % num


def hex2str(h):
    """Convert hexadecimal to printable ascii
    Usage:
        print hex2str(0x6e69622f)
    """
    chars_in_reverse = []
    while h != 0x0:
        chars_in_reverse.append(chr(h & 0xFF))
        h = h >> 8
    chars_in_reverse.reverse()
    return ''.join(chars_in_reverse)


def tmpfile(pref=""):
    """Create and return a temporary file with custom prefix"""
    return tempfile.NamedTemporaryFile(prefix=pref)


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
    try:
        xrange(0, 1)
    except NameError:
        xrange = range
    for i in xrange(0, len(src), length):
        subSrc = src[i:i+length]
        hexa = ''
        isMiddle = False
        for h in xrange(0, len(subSrc)):
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
        result.append(('%08X:  %-'+str(length*(2+1)+1)+'s  |%s|') %
                      (i, hexa, text))
    return '\n'.join(result)


def get_interfaces(family=4):
    """Gets all (interface, IPv4) of the local system.
    :family
        - 4 => shortcut for -family inet
        - 6 => shortcut for -family inet6
        - 4 => shortcut for -family link
    """
    d = subprocess.check_output('ip -%s -o addr' % str(family), shell=True)
    ifs = re.findall(
        r'^\S+:\s+(\S+)\s+inet[6]?\s+([^\s/]+)', decode_utf(d), re.MULTILINE)
    return [i for i in ifs if i[0] != 'lo']


def read(path):
    """Open file, return content"""
    path = os.path.expanduser(os.path.expandvars(path))
    if os.path.isfile(path) and os.access(path, os.R_OK):
        with open(path) as fd:
            return fd.read()
    else:
        print("ERROR: {error} is not a file or it is not readable".format(path))


def write(path, data, create_dir=False):
    """Create new file or truncate existing to zero length and write data"""
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


def xor(data, key):
    return ''.join(chr(ord(x) ^ ord(y)) for (x, y) in zip(data, itertools.cycle(key)))


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
