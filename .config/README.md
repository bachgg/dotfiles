# Tricks
```
# Suspend (must be outside of arch-chroot)
echo mem | tee /sys/power/state

# Keymaps ThinkPad P1
xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'

F1 - 121 XF86AudioMute
F2 - 122 XF86AudioLowerVolume
F3 - 123 XF86AudioRaiseVolume
F4 - 198 XF86AudioMicMute
F5 - 232 XF86MonBrightnessDown
F6 - 233 XF86MonBrightnessUp
F7 - 235 XF86Display
F8 - 246 WF86WLAN
F9 - 224 XF86Messenger
F10 - 226 XF86Go
F11 - 231 Cancel
F12 - 164 XF86Favorites

Fn - XF86WakeUp

# Scancode ThinkPad P1
sudo evtest
F1 - 113 KEY_MUTE
F2 - 114 KEY_VOLUMEDOWN
F3 - 115 KEY_VOLUMEUP


```

# Installation


```
# open another console
alt + arrow key

# list fonts
ls /usr/share/kbd/consolefonts

# bigger font size
setfont ter-120b

# verify boot mode
cat /sys/firmware/efi/fw_platform_size # should output 64

# connect to internet using wifi
iwctl
device list
device wlan0 set-property Powered on
station wlan0 scan
station wlan0 get-networks
station wlan0 connect <SSID> 
<Ctrl-D>

# test internet
ping archlinux.org

# update timezone
timedatectl set-timezone <Tab>

# disk partition
fdisk /dev/nvme1n1 # 1Tb disk
# partition 1: 1Gb
# partition 2: 1Gb
# partition 3: remaining

# format
mkfs.ext4 /dev/nvme1n1p3
mkswap /dev/nvme1n1p2
mkfs.fat -F 32 /dev/nvme1n1p1

# mount
mount /dev/nvme1n1p3 /mnt
mount --mkdir /dev/nvme1n1p1 /mnt/boot
swapon /dev/nvme1n1p2

# install packages
pacman-key --init # init keyring
pacstrap -K /mnt base linux linux-firmware

# configure filesystem
genfstab -U /mnt >> /mnt/etc/fstab

# change root
arch-chroot /mnt
pacman -S --noconfirm vim networkmanager

# time
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# localization
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# hostname
echo 'p1' > /etc/hostname

# root password
passwd

# bootloader (must be inside arch-chroot)
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# delete other boot entries
efibootmgr
efibootmgr -B -b BOOT_NUMBER

# reboot
<Ctrl-d>
reboot

```

# Inside Archlinux
```
# internet
systemctl start NetworkManager
systemctl enable NetworkManager
nmcli device wifi connect <SSID> password <password>

# pacman update
pacman -Syyu

# X
pacman -S --noconfirm xorg-server xorg-xinit xf86-video-intel nvidia xorg-xrandr arandr

# monitor setup
yay -S --noconfirm autorandr srandrd

# add user
useradd -m bach
passwd bach

# add user to sudo
pacman -S --noconfirm sudo
EDITOR=vim visudo
# uncomment: %wheel ALL=(ALL:ALL) ALL
usermod -a -G wheel bach

# AUR helper (run with user bach)
pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# display manager
yay -S --noconfirm ly
systemctl enable ly.service

# i3
yay -S --noconfirm i3

# fonts
yay -S --noconfirm wget
mkdir ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip && rm JetBrainsMono.zip

yay -S noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji
yay -S ttf-croscore

# zsh
yay -S zsh
chsh -s /usr/bin/zsh

# polybar
yay -S --noconfirm polybar

# neovim
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
yay -S --noconfirm neovim cmake ripgrep fd tmux nodejs npm lazygit bat starship exa fastfetch


# others
yay -S --noconfirm openssh

# sound
yay -S --noconfirm alsa-utils sof-firmware myxer pulseaudio
<!-- systemctl start alsa-restore.service -->
<!-- systemctl start alsa-state.service -->

# volume popup
yay -S --noconfirm libnotify dunst i3-volume
# TODO: then do copy the i3-volume config

# xremap
yay -S --noconfirm xremap-x11-bin
sudo gpasswd -a $USER input
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules

# brightness
sudo gpasswd -a $USER video
<!-- echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"' > /etc/udev/rules.d/backlight.rules -->
yay -S --noconfirm backlight_control

# networkmanager rofi
yay -S --noconfirm networkmanager-dmenu
```
