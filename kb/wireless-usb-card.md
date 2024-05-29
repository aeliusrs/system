you can use dmesg to get information of the current mode of the usb Wireless interface.

use lsusb and lsusb -t to get information about the periphery

you need a binary call usb_modeswitch
(available via the package usb-modeswitch)

usb_modeswitch -v <vendor id> -p <product id> -K

this will eject the usb, it will be then recognized as a wireless card.

You can add a UDEV rules so everytime this usb is plug it play the usb_modeswitch
command



from [morrownr](https://github.com/morrownr/USB-WiFi/blob/main/home/How_to_Modeswitch.md)
```
Ensure usb-modeswitch is installed

$ sudo apt install usb-modeswitch usb-modeswitch-data


Execute usb-modeswitch in a terminal to see if it works

$ sudo usb_modeswitch -K -W -v 0e8d -p 2870


If successful, set it up to run automatically

edit the following file

$ sudo nano  /lib/udev/rules.d/40-usb_modeswitch.rules

below the following line

SUBSYSTEM!="usb", ACTION!="add",, GOTO="modeswitch_rules_end"

add two lines

# COMFAST CF-WU782AC WiFi Dongle, TEROW ROW02FD WiFi Dongle, COMFAST CF-WU785AC WiFi Dongle
ATTR{idVendor}=="0e8d", ATTR{idProduct}=="2870", RUN+="usb_modeswitch '/%k'"

save the file ( Ctrl + x, y, Enter )

create the file /usr/share/usb_modeswitch/0e8d:2870

$ sudo nano /usr/share/usb_modeswitch/0e8d:2870

put the following inside:

# COMFAST CF-WU782AC WiFi Dongle, TEROW ROW02FD WiFi Dongle, COMFAST CF-WU785AC WiFi Dongle
TargetVendor=0x0e8d
TargetProductList="7612"
StandardEject=1

save the file ( Ctrl + x, y, Enter ) and reboot
```
