#!/usr/bin/env python3

## same can be done with nmap
## nmap -n -sL 10.10.64.0/27 | awk '/Nmap scan report/{print $NF}'

import sys
import ipaddress

for x in sys.argv[1:]:
    for ip in ipaddress.ip_network(x):
        print("{}".format(ip))
