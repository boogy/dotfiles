#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import requests

supported = """
Supported values for currency_pair:
 btcusd, btceur, eurusd, xrpusd, xrpeur, xrpbtc, ltcusd, ltceur, ltcbtc, ethusd, etheur, ethbtc, bchusd, bcheur, bchbtc
"""

if not len(sys.argv) > 1:
    for line in supported.split(","):
        print(line)
    sys.exit(1)

url = "https://www.bitstamp.net/api/v2/ticker/%s"
currency = sys.argv[1]

try:
    d = requests.get(url % currency)
    if d.status_code == 200:
        print("{} $".format(d.json()['last']))
    else:
        print("N/E")
except:
    print("N/A")

