#!/bin/sh
### BEGIN INIT INFO
# Provides:          hostname
# Required-Start:
# Required-Stop:
# Default-Start:     S
# Default-Stop:
# Short-Description: Set hostname based on /etc/hostname
### END INIT INFO

. /etc/init.d/functions
read model < /etc/model

case $1 in
	start)
		if [ ! -f /etc/hostname ]; then
			hwaddr=$(ifconfig eth0 | awk '/HWaddr/ { split($5,v,":"); print v[4] v[5] v[6] }')
			echo "${model}-${hwaddr}" > /etc/hostname
		fi

		hostname -F /etc/hostname
		;;
	*)
		echo "[$BASENAME] Usage: $0 {start}"
		;;
esac
