#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import print_function

import argparse
from os import urandom
from random import choice

char_set_complex = {
        'small': 'abcdefghijklmnopqrstuvwxyz',
        'nums': '0123456789',
        'big': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'special': '^!\$%&/()=?{[]}+~#-_.:,;<>|\\'
    }

char_set_simple = {
        'small': 'abcdefghijklmnopqrstuvwxyz',
        'nums': '0123456789',
        'big': 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    }


def generate_pass(length=21, simple=False):
    """Function to generate a password"""

    if simple:
        chars_dict = char_set_simple
    else:
        chars_dict = char_set_complex

    password = []

    while len(password) < length:
        key = choice(chars_dict.keys())
        a_char = urandom(1)
        if a_char in chars_dict[key]:
            if check_prev_char(password, chars_dict[key]):
                continue
            else:
                password.append(a_char)
    return ''.join(password)


def gen_pass(number, length, ptype):
    """Wrapper function to call multiple times generate_pass"""
    passwords = []
    for x in range(0, number):
        passwords.append(generate_pass(length, ptype))
    return "\n".join(passwords)


def check_prev_char(password, current_char_set):
    """Function to ensure that there are no consecutive
    UPPERCASE/lowercase/numbers/special-characters."""

    index = len(password)
    if index == 0:
        return False
    else:
        prev_char = password[index - 1]
        return bool(prev_char in current_char_set)
        # if prev_char in current_char_set:
        #     return True
        # else:
        #     return False


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Create a random password")
    parser.add_argument(
        "-c", "--count",
        help="How many passwords to generate (default 10)",
        action="store",
        dest="count",
        default=10
    )
    parser.add_argument(
        "-l", "--length",
        help="The length of the password (default 15)",
        action="store",
        dest="length",
        default=15
    )
    parser.add_argument(
        "-n", "--normal",
        help="Password type to normal characters [a-zA-Z0-9] (Defaults to full ascii)",
        action="store_true",
        dest="normal",
        default=False
    )

    args = parser.parse_args()
    print(gen_pass(int(args.count), int(args.length), args.normal))

