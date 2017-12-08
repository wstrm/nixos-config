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

# Insert USB with SSH keys and mount, then...
install -m 600 <id_rsa here> <id_rsa.pub here> ~/.ssh/
git clone git@github.com:willeponken/nixos-config.git /tmp/nixos-config
cp -a /tmp/nixos-config/. /mnt/etc/nixos/.

nixos-install
reboot
```
