# Archlinux

# System infos

  * 20N3S4AJ00 (LENOVO_MT_20N3_BU_Think_FM_ThinkPad T490)
  * 24GiB System Memory
  * Intel(R) Core(TM) i7-8565U CPU @ 1.80GHz
  * UHD Graphics 620 (Whiskey Lake)
  * NVIDIA GP108M [GeForce MX250]
  * kernel : 4.19 lts

# Install throttled

  * install throttled -> [github repo](https://github.com/erpalma/throttled)

```bash
$ sudo pacman -S throttled
$ sudo systemctl enable --now lenovo_fix.service
```

# CPU throttling partial fix

[LINK TO REDDIT POST](https://www.reddit.com/r/linux/comments/9n5ajg/first_part_of_the_real_fix_for_ultrabook_cpu/)

Create a systemd service unit which will set the proper UUID for the thermal zone which has a `type` of `INT3400:00`


```bash
$ cat /sys/class/thermal/thermal_zone1/type
INT3400 Thermal
```

```bash
$ cat /etc/systemd/system/fix-thermal-uuid.service
[Unit]
Description=Set proper UUID for thermal_zone1

[Service]
Type=oneshot
ExecStart=/bin/bash -c "echo $(cat /sys/devices/platform/INT3400:00/uuids/available_uuids|grep 63BE) > /sys/devices/platform/INT3400:00/uuids/current_uuid; echo enabled > /sys/class/thermal/thermal_zone1/mode"
RemainAfterExit=yes

[Install]
WantedBy=default.target
```

# Disable NVIDIA card without bbswitch or bumblebee

`bbswitch` does not seem to be able to power off the nvidia dGPU on the T490. There is a possibility by using the kernel power management.

  * create a systemd service and enabled on boot
  * check using `powertop` or similar tools if the dGPU is still consuming power

```bash
$ cat /etc/systemd/system/gpuoff.service
[Unit]
Description=Power-off gpu

[Service]
Type=oneshot
ExecStart=/bin/bash -c "echo auto > /sys/bus/pci/devices/0000:3c:00.0/power/control"
; ExecStart=/bin/bash -c "echo 1 > /sys/bus/pci/devices/0000:3c:00.0/remove"
ExecStop=/bin/bash -c "echo 1 > /sys/bus/pci/rescan"

[Install]
WantedBy=default.target
$ sudo systemctl daemon-reload
$ sudo systemctl enable --now gpuoff.service
```

# Setup F11 and F12 special keys
For Lenovo ThinkPad T490 F11 and F12 spcial keys:

```bash
$ sudo cat /etc/udev/hwdb.d/90-thinkpad-keyboard.hwdb
   evdev:name:ThinkPad Extra Buttons:dmi:bvn*:bvr*:bd*:svnLENOVO*:pn*
    KEYBOARD_KEY_45=prog1
    KEYBOARD_KEY_49=prog2
$ sudo udevadm hwdb --update
$ sudo udevadm trigger --sysname-match="event*"
```
Their names will be "`XF86Launch2`" (KEY_KEYBOARD) and "`XF86Launch1`" (KEY_FAVORITES). Use in i3 to run a program.
