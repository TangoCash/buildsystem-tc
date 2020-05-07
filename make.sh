#!/bin/bash

##############################################

if [ "$(id -u)" = "0" ]; then
	echo ""
	echo "You are running as root. Do not do this, it is dangerous."
	echo "Aborting the build. Log in as a regular user and retry."
	echo ""
	exit 1
fi

##############################################

if [ "$1" == -h ] || [ "$1" == --help ]; then
	echo "Usage: $0 [-v | --verbose | -q | --quiet] [Parameter1 Parameter2 ... Parameter6]"
	echo
	echo "-v or --verbose : verbose build (very noisy!)"
	echo "-q or --quiet   : quiet build, fastest, almost silent"
	echo "Parameter 1     : target system"
	echo "Parameter 2     : Toolchain gcc version"
	echo "Parameter 3     : optimization"
	echo "Parameter 4     : Neutrino variant"
	echo "Parameter 5     : External LCD support"
	echo "Parameter 6     : Image layout for hd51 / bre2ze4k or vusolo4k multiboot"
	exit
fi

##############################################

echo "                        ()                               "
echo "  ____ ___   ___  __  __|/___                            "
echo " |  _ \ _ \ / _ \ \ \/ // __|                            "
echo " | | | | | | (_| | >  < \__ \\                           "
echo " |_| |_| |_|\__,_|/_/\_\|___/                            "
echo "  _           _ _     _               _                  "
echo " | |         (_) |   | |             | |                 "
echo " | |__  _   _ _| | __| |___ _   _ ___| |_____  ___ ___   "
echo " |  _ \| | | | | |/ _  / __| | | / __| __/ _ \/ _ v _ \\ "
echo " | |_) | |_| | | | (_| \__ \ |_| \__ \ ||  __/ | | | | | "
echo " |_.__/\__,_\|_|_|\__,_|___/\__, |___/\__\___|_| |_| |_| "
echo "                             __/ |                       "
echo "                            |___/                        "

##############################################

if [ "$1" == -v ] || [ "$1" == --verbose ]; then
	shift
	KBUILD_VERBOSE=1
elif [ "$1" == -q ] || [ "$1" == --quiet ]; then
	shift
	KBUILD_VERBOSE=0
else
	KBUILD_VERBOSE=0
fi
echo "KBUILD_VERBOSE=$KBUILD_VERBOSE" > .config

##############################################

case $1 in
	[1-9] | 1[0-9] | 2[0-9] | 3[0-9] | 4[0-9]) REPLY=$1;;
	*)
		echo "Target receivers:"
		echo "   1)  VU+ Duo"
		echo "   2)  VU+ Duo 4K"
		echo "   3)  VU+ Solo 4k"
		echo "   4)  VU+ Ultimo 4K"
		echo "   5)  VU+ Uno 4K"
		echo "   6)  VU+ Uno 4K SE"
		echo "   7)  VU+ Zero 4K"
		echo "  11)  WWIO BRE2ZE 4K"
		echo "  21)  AX/Mut@nt HD51"
		echo "  22)  AX/Mut@nt HD60"
		echo "  23)  AX/Mut@nt HD61"
		echo "  30)  Edision OS mio 4K"
		echo "  31)  Edision OS mio+ 4K"
		echo "  40)  AirDigital Zgemma H7C/H7S"
		read -p "Select target? [21] "
		REPLY="${REPLY:-21}";;
esac

case "$REPLY" in
	 1) BOXARCH="mips";BOXTYPE="mipsbox";BOXMODEL="vuduo";;
	 2) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="vuduo4k";;
	 3) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="vusolo4k";;
	 4) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="vuultimo4k";;
	 5) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="vuuno4k";;
	 6) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="vuuno4kse";;
	 7) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="vuzero4k";;
	11) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="bre2ze4k";;
	21) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="hd51";;
	22) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="hd60";;
	23) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="hd61";;
	30) BOXARCH="aarch64";BOXTYPE="armbox";BOXMODEL="osmio4k";;
	31) BOXARCH="aarch64";BOXTYPE="armbox";BOXMODEL="osmio4kplus";;
	40) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="h7";;
	 *) BOXARCH="arm";BOXTYPE="armbox";BOXMODEL="hd51";;
esac
echo "BOXARCH=$BOXARCH" >> .config
echo "BOXTYPE=$BOXTYPE" >> .config
echo "BOXMODEL=$BOXMODEL" >> .config

##############################################

case $2 in
	[1-4]) REPLY=$2;;
	*)	echo -e "\nToolchain gcc version:"
		echo "   1) GCC version 6.5.0"
		echo "   2) GCC version 7.5.0"
		echo "   3) GCC version 8.3.0"
		echo "   4) GCC version 9.2.0"
		read -p "Select toolchain gcc version (1-4)? [4] "
		REPLY="${REPLY:-4}";;
esac

case "$REPLY" in
	1) BS_GCC_VER="6.5.0";;
	2) BS_GCC_VER="7.5.0";;
	3) BS_GCC_VER="8.3.0";;
	4) BS_GCC_VER="9.2.0";;
	*) BS_GCC_VER="9.2.0";;
esac
echo "BS_GCC_VER=$BS_GCC_VER" >> .config

##############################################

case $3 in
	[1-3]) REPLY=$3;;
	*)	echo -e "\nOptimization:"
		echo "   1)  optimization for size"
		echo "   2)  optimization normal"
		echo "   3)  debug"
		read -p "Select optimization (1-3)? [1] "
		REPLY="${REPLY:-1}";;
esac

case "$REPLY" in
	1)  OPTIMIZATIONS="size";;
	2)  OPTIMIZATIONS="normal";;
	3)  OPTIMIZATIONS="debug";;
	*)  OPTIMIZATIONS="size";;
esac
echo "OPTIMIZATIONS=$OPTIMIZATIONS" >> .config

##############################################

case $4 in
	[1-4]) REPLY=$4;;
	*)	echo -e "\nWhich Neutrino variant do you want to build?:"
		echo "   1)  neutrino-ddt   "
		echo "   2)  neutrino-max   "
		echo "   3)  neutrino-ni    "
		echo "   4)  neutrino-tangos"
		read -p "Select Image to build (1-4)? [4] "
		REPLY="${REPLY:-4}";;
esac

case "$REPLY" in
	1) FLAVOUR="neutrino-ddt";;
	2) FLAVOUR="neutrino-max";;
	3) FLAVOUR="neutrino-ni";;
	4) FLAVOUR="neutrino-tangos";;
	*) FLAVOUR="neutrino-tangos";;
esac
echo "FLAVOUR=$FLAVOUR" >> .config

##############################################

case $5 in
	[1-4]) REPLY=$5;;
	*)	echo -e "\nExternal LCD support:"
		echo "   1)  No external LCD"
		echo "   2)  graphlcd for external LCD"
		echo "   3)  lcd4linux for external LCD"
		echo "   4)  graphlcd and lcd4linux for external LCD (both)"
		read -p "Select external LCD support (1-4)? [4] "
		REPLY="${REPLY:-4}";;
esac

case "$REPLY" in
	1) EXTERNAL_LCD="none";;
	2) EXTERNAL_LCD="graphlcd";;
	3) EXTERNAL_LCD="lcd4linux";;
	4) EXTERNAL_LCD="both";;
	*) EXTERNAL_LCD="both";;
esac
echo "EXTERNAL_LCD=$EXTERNAL_LCD" >> .config

##############################################

if [ $BOXMODEL == 'hd51' -o $BOXMODEL == 'bre2ze4k'  -o $BOXMODEL == 'h7' ]; then

case $6 in
	[1-3]) REPLY=$6;;
	*)	echo -e "\nImage-Layout:"
		echo "   1)  4 single"
		echo "   2)  1 single + multiroot"
		echo "   3)  1 single + multiroot + swap"
		read -p "Select layout (1-3)? [3] "
		REPLY="${REPLY:-3}";;
esac

case "$REPLY" in
	1)  NEWLAYOUT="0";NEWLAYOUT_SWAP="0";;
	2)  NEWLAYOUT="1";NEWLAYOUT_SWAP="0";;
	3)  NEWLAYOUT="1";NEWLAYOUT_SWAP="1";;
	*)  NEWLAYOUT="1";NEWLAYOUT_SWAP="1";;
esac
echo "NEWLAYOUT=$NEWLAYOUT" >> .config
echo "NEWLAYOUT_SWAP=$NEWLAYOUT_SWAP" >> .config

fi

if [ $BOXMODEL == 'hd60' ]; then
echo "NEWLAYOUT=1" >> .config
fi

if [ $BOXMODEL == 'vuduo' ]; then
echo "NEWLAYOUT=0" >> .config
fi

if [ $BOXMODEL == 'vuduo4k' -o \
     $BOXMODEL == 'vusolo4k' -o \
     $BOXMODEL == 'vuultimo4k' -o \
     $BOXMODEL == 'vuuno4k' -o \
     $BOXMODEL == 'vuuno4kse' -o \
     $BOXMODEL == 'vuzero4k' \
    ]; then

case $6 in
	[1-2]) REPLY=$6;;
	*)	echo -e "\nNormal or MultiBoot:"
		echo "   1)  Normal"
		echo "   2)  Multiboot"
		read -p "Select mode (1-2)? [2] ";;
esac

case "$REPLY" in
	1)  VU_MULTIBOOT="0";;
	2)  VU_MULTIBOOT="1";;
	*)  VU_MULTIBOOT="1";;
esac
echo "NEWLAYOUT=0" >> .config
echo "VU_MULTIBOOT=$VU_MULTIBOOT" >> .config

fi

##############################################
echo " "
make printenv
##############################################
echo "Your next step could be:"
echo "  make neutrino"
echo "  make flashimage"
echo "  make ofgimage"
echo " "
