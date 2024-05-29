you can use dmesg to get information of the current mode of the usb Wireless interface.

use lsusb and lsusb -t to get information about the periphery

you need a binary call usb_modeswitch
(available via the package usb-modeswitch)

usb_modeswitch -v <vendor id> -p <product id> -K

this will eject the usb, it will be then recognized as a wireless card.

You can add a UDEV rules so everytime this usb is plug it play the usb_modeswitch
command
