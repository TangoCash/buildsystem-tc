#!/bin/sh

device1=$(blkid -t  PARTLABEL="swap" -o device | head -n1)
swap1=$(cat /proc/swaps | grep -o "$device1" | head -n1)

if [ "$device1" == "" ]; then
	echo "  Sorry, no swap drive found"
	exit 1
fi

grep -q "$device1" /etc/fstab

if [ $? -ne 0 ]; then
	mkswap $device1
	swapon $device1
	echo "$device1 none swap defaults 0 0" >> /etc/fstab
elif [ "$swap1" == "" ]; then
	mkswap $device1
	swapon $device1
fi
