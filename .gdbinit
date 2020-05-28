define xesp
    x/32x $esp
end

define xrsp
    x/32xw $rsp
end

define xall
  i r eip esp ebp eax
  x/5i $eip
  x/32xw $esp
end

define xenv
    x/20s *environ
end

define ib
    info breakpoins
end

define loop-print-eip
    while 1
        x/i $pc
        stepi
    end
end

##
## Load gdb helper scripts
##

define load-peda
    source ~/tools/peda/peda.py
end

define load-pwndbg
    source ~/tools/pwndbg/gdbinit.py
end

define libheap
    python from libheap import *
end

##
## Attach to the pid of a program more easily
##
define attach-pidof
  if $argc != 1
   help attach-pidof
  else
   shell echo -e "\
set \$PID = "$(echo $(pidof $arg0) 0 | cut -d ' ' -f 1)"\n\
if \$PID > 0\n\
  attach "$(pidof -s $arg0)"\n\
else\n\
  print \"Process '"$arg0"' not found\"\n\
end" > /tmp/gdb.pidof
   source /tmp/gdb.pidof
  end
end
document attach-pidof
Attach to process by name.
Usage: attach-pidof PROG_NAME
end

load-pwndbg
#python from libheap import *
