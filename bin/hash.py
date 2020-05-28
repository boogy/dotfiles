#!/usr/bin/env python3

import hashlib
import sys

utf_enc = lambda x: x.encode('utf-8', 'ignore')
ascii_enc = lambda x: x.encode('ascii', 'ignore')

if len(sys.argv) > 2:
    algo = sys.argv[1]
    text = sys.argv[2]

    if hasattr(hashlib, algo):
        f = getattr(hashlib, algo)
        print("Algo {}".format(algo))
        print(f(utf_enc(text)).hexdigest())
    else:
        print("There is no such algorithm ...")
else:
    print("Usage: {} <hashlib algorithm> <string>".format(sys.argv[0]))
    sys.exit(0)
