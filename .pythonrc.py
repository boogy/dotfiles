#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys

try:
    sys.path.append(os.path.expanduser("~/bin"))
    from mylib import *
except:
    pass

try:
    from jedi.utils import setup_readline
    setup_readline()
except ImportError:
    # Fallback to the stdlib readline completer if it is installed.
    # Taken from http://docs.python.org/2/library/rlcompleter.html
    print("Jedi is not installed, falling back to readline")
    try:
        import readline
        import rlcompleter
        # readline.parse_and_bind("tab: complete")
        if 'libedit' in readline.__doc__:
            readline.parse_and_bind("bind ^I rl_complete")
        else:
            readline.parse_and_bind("tab: complete")
    except ImportError:
        print("Readline is not installed either. No tab completion is enabled.")
