#!/usr/bin/env python3

import sys
import subprocess
import argparse
import os

from netaddr import *

def reversedns(ip, dns_server):
    a = subprocess.check_output(["dig", "@{}".format(dns_server) , "+noall", "+answer", "-x", ip])
    b = a.expandtabs()
    c = b.decode("utf-8").split('\n')

    hn = []
    for i in range(len(c)-1):
        tmp_hn=c[i].split()[4].rstrip('.')
        hn.append(tmp_hn)

    hn.sort()
    return hn


def run(ip_ranges, dns_server):
    ips = []
    for x in ip_ranges:
        for ip in IPNetwork(x):
            ips.append(ip)

    for i in range(0, len(ips)):
        print("{} -> {}".format(
                ips[i], reversedns(str(ips[i]), dns_server)
            ))



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Mass DNS reverse lookup script')
    parser.add_argument(
        '-d', '--dns',
        help='DNS server to use for the lookup (default: 8.8.8.8)',
        dest="dns_server",
        default="8.8.8.8",
    )
    parser.add_argument(
        '-f',
        '--file',
        help="Input file with ip ranges",
        dest="file",
    )
    args = parser.parse_args()

    ip_ranges = []
    dns = args.dns_server

    if args.file and os.path.isfile(args.file):
        with open(args.file, 'r') as f:
            for line in f:
                ip_ranges.append(line)
        print("DNS Server: {}".format(args.dns_server))
        print("IP ragnes : {}".format(ip_ranges))
        run(ip_ranges, dns)

