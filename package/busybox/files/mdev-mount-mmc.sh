#!/bin/sh
ENABLE_LOG=1
LOG="/tmp/mdev.log"
MOUNTBASE=/media
MOUNTPOINT="$MOUNTBASE/$MDEV"
ROOTDEV=$(readlink /dev/root)
BLOCKS="/sys/block/mmcblk0/mmcblk0p*/uevent"
KERNELDEV=""
K_PARTNAME=""
ROOTFSDEV=""
R_PARTNAME=""
ROOTSUBDIR=""
NEWLAYOUT=0
# to use partnames in old layout, set it to 1
USE_PARTNAMES=0
#
loginfo()
{
OUT=$1
if [ "$ENABLE_LOG" == "1" ];then
	logleft="[$ACTION] $(date +'%H:%M:%S') [$MDEV]"
	echo "$logleft $OUT" >> $LOG
else
	logleft="[$ACTION] $(date +'%H:%M:%S') [$MDEV]"
	echo "$logleft $OUT"
fi
}
#
check_mmcblk()
{
devname=""
partname=""
for i in $BLOCKS;do
	if [ "$i" != "$BLOCKS" ];then
		devname=$(cat $i | grep DEVNAME | cut -d '=' -f 2)
		if [ "$devname" == "$MDEV" ];then
			partname=$(cat $i | grep PARTNAME | cut -d '=' -f 2)
			if [ -n "$(echo $partname | grep 'kernel')" ];then
				KERNELDEV=$devname
				K_PARTNAME=$partname
				break
			elif [ -n "$(echo $partname | grep 'rootfs')" ];then
				ROOTFSDEV=$devname
				R_PARTNAME=$partname
				if [ -n "$(echo $partname | grep 'linuxrootfs')" ];then
					NEWLAYOUT=1
					R_PARTNAME="linuxrootfs1"
				fi
				break
			elif [ -n "$(echo $partname | grep 'userdata')" ];then
				ROOTFSDEV=$devname
				R_PARTNAME=$partname
				NEWLAYOUT=1
				break
			fi
		fi
	fi
done
[ "$partname" == "swap" -o "$partname" == "swapdata" ] && exit 0
[ "$NEWLAYOUT" == "1" -o "$USE_PARTNAMES" == "1" ] && MOUNTPOINT="$MOUNTBASE/$R_PARTNAME"
}
#
read_cmdline()
{
for param in $(cat /proc/cmdline);do
	if [ -n "$(echo $param | grep rootsubdir)" ];then
		ROOTSUBDIR=$(echo $param | cut -d '=' -f 2)
		break
	fi
done
}
# check partition names
check_mmcblk
# do not add or remove root device again...
[ "$ROOTDEV" == "$MDEV" -a "$R_PARTNAME" != "userdata" ] && loginfo "no action on /dev/$MDEV --> do not add or remove root device [$R_PARTNAME] again..." && exit 0

if [ -e /tmp/.nomdevmount ]; then
	loginfo "no action on $MDEV --> /tmp/.nomdevmount exists"
	exit 0
fi

BLKID=$(blkid -c /dev/null /dev/$MDEV)
eval ${BLKID#*:}

case "$ACTION" in
	add)
		# do not mount kernel partitions
		if [ "$KERNELDEV" == "$MDEV" ];then
			loginfo "/dev/$MDEV is a kernel partition [$K_PARTNAME] - not mounting."
			exit 0
		fi
		# TODO: check for partitions
		if [ "$NEWLAYOUT" == "1" ];then
			if grep -q $MOUNTPOINT /proc/mounts; then
				loginfo "/dev/$MDEV already mounted [$R_PARTNAME] - not mounting again"
				exit 0
			fi
			mkdir -p /tmp/$MDEV
			mount -t $TYPE /dev/$MDEV /tmp/$MDEV 2>&1 >/dev/null
			RET=$?
			[ $RET != 0 ] && loginfo "mount /dev/$MDEV to /tmp/$MDEV failed with $RET" && rmdir /tmp/$MDEV
			if [ "$R_PARTNAME" == "linuxrootfs1" ];then
				loginfo "mounting /dev/$MDEV [$R_PARTNAME] to $MOUNTPOINT"
				mkdir -p $MOUNTPOINT
				mount --bind /tmp/$MDEV/linuxrootfs1 $MOUNTPOINT
			elif [ "$R_PARTNAME" == "userdata" ];then
				# parse cmdline for rootsubdir
				read_cmdline
				for i in /tmp/$MDEV/*;do
					if [ -n "$(echo $i | grep linuxrootfs)" ];then
						if [ "$ROOTSUBDIR" == "$(basename $i)" ];then
							loginfo "/dev/$MDEV rootsubdir [$ROOTSUBDIR] is already mounted as root"
							continue
						fi
						MOUNTPOINT="$MOUNTBASE/$(basename $i)"
						if grep -q $MOUNTPOINT /proc/mounts; then
							loginfo "/dev/$MDEV already mounted [$(basename $i)] - not mounting again"
						else
							loginfo "mounting /dev/$MDEV [$(basename $i)] to $MOUNTPOINT"
							mkdir -p $MOUNTPOINT
							mount --bind /tmp/$MDEV/$(basename $i) $MOUNTPOINT
						fi
					fi
				done
			fi
			umount -lf /tmp/$MDEV
			RET=$?
			if [ $RET = 0 ]; then
				rmdir /tmp/$MDEV
			else
				loginfo "umount /tmp/$MDEV failed with $RET"
			fi
		else
			if grep -q "/dev/$MDEV" /proc/mounts; then
				loginfo "/dev/$MDEV already mounted [$R_PARTNAME] - not mounting again"
				exit 0
			fi
			loginfo "mounting /dev/$MDEV [$R_PARTNAME] to $MOUNTPOINT"
			# remove old mountpoint symlinks we might have for this device
			rm -f $MOUNTPOINT
			mkdir -p $MOUNTPOINT
			mount -t $TYPE /dev/$MDEV $MOUNTPOINT 2>&1 >/dev/null
			RET=$?
			if [ $RET != 0 ]; then
				loginfo "mount /dev/$MDEV to $MOUNTPOINT failed with $RET"
				rmdir $MOUNTPOINT
			fi
		fi
		;;
	# I think never comes a 'remove' from mdev, because never the mmcblock will be removed
	# It can be used for manually ( or per script ) umounting
	remove)
		loginfo "umounting $MOUNTBASE/$MDEV"
		grep -q "$MOUNTBASE/$MDEV " /proc/mounts || exit 0 # not mounted...
		umount -lf $MOUNTBASE/$MDEV
		RET=$?
		if [ $RET = 0 ]; then
			rmdir $MOUNTBASE/$MDEV
		else
			loginfo "umount $MOUNTBASE/$MDEV failed with $RET"
		fi
		;;
esac
exit 0
