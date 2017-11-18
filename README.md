nixos-config
============

```
gdisk /dev/sda # o, n <500M, ef00>, n <8e00>, w

cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 pv

pvcreate /dev/mapper/pv
vgcreate vg /dev/mapper/pv
lvcreate -L 4G -n swap vg
lvcreate -l '100%FREE' -n root vg

mkfs.fat /dev/sda1
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap

mount /dev/vg/root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/vg/swap

nixos-generate-config --root /mnt

# Only for WiFi
cat > /etc/wpa_supplicant.conf
network={
  ssid="****"
  psk="****"
}
^D
systemctl start wpa_supplicant

# This is kind of stupid, make sure nothing important gets overwritten
curl -L https://github.com/willeponken/nixos-config/archive/master.zip > /tmp/nixos-config.zip
unzip /tmp/nixos-config.zip -d /tmp/
cp -R /tmp/nixos-config-master/. /mnt/etc/nixos/.

nixos-install
reboot
```
