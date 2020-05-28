# Configuration file for ipython.
c = get_config()

c.InteractiveShell.cache_size = 1000
# lines of code to run at IPython startup.
c.InteractiveShellApp.exec_lines = [
        "%autoreload 2",
        "import os",
        "import re",
        "import sys",
        "import requests",
        "sys.path.append(os.path.expanduser('~/bin'))",
        "from mylib import *",
        "from pwn import *",
        ]

c.InteractiveShellApp.extensions = [
            'autoreload'
            ]

# List of files to run at IPython startup.
# c.InteractiveShellApp.exec_files = ["mylib.py"]

# Set the log level by value or name.
# c.TerminalIPythonApp.log_level = 30
# c.TerminalIPythonApp.log_level = 20
c.TerminalInteractiveShell.prompts_class.log_level = 20

# lines of code to run at IPython startup.
# c.TerminalIPythonApp.exec_lines = []

# A boolean that determines if there should be no blank lines between prompts
# c.TerminalIPythonApp.nosep = False
c.TerminalInteractiveShell.prompts_class.nosep = False
# c.TerminalIPythonApp.display_banner = True
c.TerminalInteractiveShell.prompts_class.display_banner = False
# c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.prompts_class.confirm_exit = False

c.InteractiveShell.autoindent = True
c.InteractiveShell.deep_reload = True
c.InteractiveShell.editor = 'vim'
c.InteractiveShell.colors = 'LightBG'

# c.PromptManager.justify = True
c.TerminalInteractiveShell.prompts_class.justify = True

c.AliasManager.user_aliases = [
         ('la', 'ls -al'),
         ('ll', 'ls -l'),
         ('cp', 'cp -i'),
         ('mv', 'mv -i'),
         ('cd..', 'cd ../../'),
         ('cd...', 'cd ../../../'),
         ('chown', 'chown --preserve-root'),
         ('chmod', 'chmod --preserve-root'),
         ('chgrp', 'chgrp --preserve-root'),
         ('br_conf', 'vim ~/.bashrc'),
         ('ba_conf', 'vim ~/.bash_aliases'),
         ('a_search', 'aptitude search'),
         ('a_install', 'sudo aptitude install'),
         ('a_update', 'sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove'),
         ('a_show', 'sudo apt-cache show'),
         ('a_info', 'sudo apt-cache showpkg'),
         ('openports', 'netstat -nape --inet'),
         ('ports', 'netstat -lapute'),
         ('monittcp', 'sudo watch -n 1 "netstat -tpanl | grep ESTABLISHED"'),
         ('listening', 'sudo lsof -P -i -n'),
         ('mkdir', 'mkdir -p'),
         ('rabin', 'rabin2'),
         ]

c.PrefilterManager.multi_line_specials = True
