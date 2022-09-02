#!/bin/bash

# Set the timezone
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Generate /etc/adjtime
hwclock --systohc

# Generate locales
sed -i "s/#en_US\.UTF-8/en_US\.UTF-8/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set keyboard layout
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

# Create hostname file
echo "leon" > /etc/hostname
echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.0.1 leon" > /etc/hosts
pacman -S networkmanager
systemctl enable NetworkManager

# Creating a new initramfs
mkinitcpio -P

# Installing a bootloader
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Installing some packages
pacman -S git vim nvim base-devel sudo zsh wget network-manager-applet dhcpcd dhcp iptables openssh unzip \									# Basic packages
	xorg bspwm sxhkd picom lightdm lightdm-webkit2-greeter rofi nitrogen feh dunst \														# Desktop environment
	alsa alsa-utils alsa-firmware pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pavucontrol blueman acpilight \		# Drivers
	alacritty neofetch  nitrogen polybar papirus-icon-theme \ 																				# Ricing
	go ruby code docker docker-compose python python-pip nodejs npm terraform\ 																# Coding
	flameshot ranger thunar globalprotect-openconnect chromium firefox \ 																	# Other programs
	arandr imagemagick wmname																												# Tools

# Enable services
systemctl enable lightdm
systemctl enable iptables

# Set password
passwd

echo "Arch install script finished!"
