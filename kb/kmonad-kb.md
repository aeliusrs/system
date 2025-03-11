```bash
# Add self to the input and uinput groups
sudo usermod -aG input $USER
sudo groupadd uinput
sudo usermod -aG uinput $USER

echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/90-uinput.rules

# This seems to be needed because uinput isn't compiled as a loadable module these days.
# See https://github.com/chrippa/ds4drv/issues/93#issuecomment-265300511
echo uinput | sudo tee /etc/modules-load.d/uinput.conf

mkdir -p ~/.config/kmonad
touch ~/.config/kmonad/config.kbd

cat << EOF >> ~/.config/kmonad/config.kbd
(defcfg
  input  (device-file "<path to your keyboard input>")
  output (uinput-sink "KMonad kbd"))


# Go to /dev/input/by-path/ or /dev/input/by-id/ and look for any file ending in kbd.
# I think if your keyboard is plugable, it should appear in /dev/input/by-id/ and your build-in laptop keyboard should appear in /dev/input/by-path/.


(defsrc
  esc   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11   f12    pause  prnt  ins  del
  `     1    2    3    4    5    6    7    8    9    0    -     =      bspc              home
  tab   q    w    e    r    t    y    u    i    o    p    [     ]      ret               pgup
  caps  a    s    d    f    g    h    j    k    l    ;    '     \                        pgdn
  lsft  z    x    c    v    b    n    m    ,    .    /    rsft         up                end
  lctl  lmet lalt      spc       ralt cmps rctl                 left   down   rght
  )

(deflayer base
  caps  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11   f12    pause  prnt  ins  del
  `     1    2    3    4    5    6    7    8    9    0    -     =      bspc              home
  tab   q    w    e    r    t    y    u    i    o    p    [     ]      ret               pgup
  esc  a    s    d    f    g    h    j    k    l    ;    '     \                        pgdn
  lsft  z    x    c    v    b    n    m    ,    .    /    rsft         up                end
  lctl  lmet lalt      spc       ralt cmps rctl                 left   down   rght
  )

kmonad ~/path/to/config

```
