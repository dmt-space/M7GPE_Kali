#!/bin/bash

DEV_BOARD="m7"
DEV_DESC="HTC One M7 GPE"
DEV_ARCH="armhf"
DEV_BLOCK="/dev/block/platform/msm_sdcc.1/by-name/boot"
KERN_CONFIG="m7gpekali_defconfig"
KERN_BUILDVER="1.4"
KERN_STRING="Kali M7 GPE"
KERN_AUTHOR="Lavanoid"
KERN_ANDROIDVER="lollipop"
KERN_ANDROIDVNO="5.1.1 Lollipop"
KALI_DEVNAME="onem7gpe"
BUILD_CORES="2"
NH_DEVDIR="kali-nethunter/nethunter-installer/devices"
KERNEL_GIT="https://github.com/lavanoid/android_kernel_htc_m7gpe.git -b android-5.1"

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    OS="SUSE"
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    OS="RedHat"
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

echo $OS



if [[ ${OS} = *"Manjaro"* ]] || [[ ${OS} = *"Arch"* ]]; then
    if ! (pacman -Qi aosp-devel); then
        echo "[CONFIGURE] Installing dependencies..."
        sudo pacman -S --needed yay
        yay -Syy
        yay -S aosp-devel
    fi
    if ! (pacman -Qi python2-requests); then
        sudo pacman -S --needed yay
        yay -Syy
        yay -S python-virtualenv python2-virtualenv python-requests python2-requests
    fi
    echo "[CONFIGURE] Enabling Python virtual environment..."
    virtualenv2 -p $(which python2) --system-site-packages $(pwd)
    #virtualenv -p $(which python2) --system-site-packages $(pwd)
    source $(pwd)/bin/activate
fi
if [[ ${OS} = *"Debian"* ]] || [[ ${OS} = *"Ubuntu"* ]]; then
    echo "[CONFIGURE] Installing dependencies..."
    sudo apt-get update
    sudo apt-get install build-essential git wget curl libncurses-dev python-requests python-venv -y
fi

if NPROC=$(nproc); then
    echo "[INFORMATION] Total CPU threads: $NPROC"
    echo "[CONFIGURE] Using the maximum No. of processing threads available...."
    BUILD_CORES="$NPROC"
fi

#This will appear in the kernel string, such as "root@kali".
HOST="kali"

echo "[CONFIGURE] Changing system host name to '"$HOST"'..."
# Backup the original hostname, then change it to the value of "HOST".
ORIGINALHOSTNAME=$(hostname)
echo "Original hostname: $ORIGINALHOSTNAME"
export HOSTNAME=$HOST
sudo hostname "$HOST"
echo "Current hostname: "`hostname`
sleep 2

echo "[CONFIGURE] Downloading arm toolchain..."
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7 toolchain

echo "[CONFIGURE] Setting path variables..."
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=`pwd`/toolchain/bin/arm-eabi-
export PATH=$PATH:`pwd`/toolchain/bin

if [[ ! -d "./kernel" ]]; then
    echo "[CONFIGURE] Downloading kernel source code..."
    git clone $KERNEL_GIT ./kernel
fi

echo "[CONFIGURE] Downloading Kali Nethunter..."
git clone https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project kali-nethunter
cd kali-nethunter
git pull origin master
cd ..

if [[ $1 != "--nokern" ]]; then
    if [[ -f "$KERN_CONFIG" ]]; then
        echo "[CONFIGURE] Copying Kali default configuration..."
        cp -f "$KERN_CONFIG" "kernel/arch/arm/configs/$KERN_CONFIG"
    fi

    cd kernel
    #if [[ ! -f "mac80211.compat08082009.wl_frag+ack_v1.patch" ]]; then
    #    echo "[PATCH] Patching 802.11..."
    #    wget http://patches.aircrack-ng.org/mac80211.compat08082009.wl_frag+ack_v1.patch
    #    patch -p1 < mac80211.compat08082009.wl_frag+ack_v1.patch
    #fi

    echo "[BUILD] Building kernel for $DEV_DESC $KERN_ANDROIDVNO"
    make clean
    make $KERN_CONFIG
    time make -j$BUILD_CORES
    sleep 2
    cd ..
fi

echo "CD: "$(pwd)
echo "Creating directory $NH_DEVDIR"
mkdir -p $NH_DEVDIR
sleep 2
if [[ $(cat $NH_DEVDIR/devices.cfg | grep "$KALI_DEVNAME") == "" ]]; then
    echo "[CONFIGURE] Adding $KALI_DEVNAME to devices.cfg..."
    echo "">> $NH_DEVDIR/devices.cfg
    echo "# "$DEV_DESC>> $NH_DEVDIR/devices.cfg
    echo "["$KALI_DEVNAME"]">> $NH_DEVDIR/devices.cfg
    echo "author = \"$KERN_AUTHOR\"">> $NH_DEVDIR/devices.cfg
    echo "version = \"$KERN_BUILDVER\"">> $NH_DEVDIR/devices.cfg
    echo "kernelstring = \"$KERN_STRING\"">> $NH_DEVDIR/devices.cfg
    echo "arch = $DEV_ARCH">> $NH_DEVDIR/devices.cfg
    echo "devicenames = $DEV_BOARD">> $NH_DEVDIR/devices.cfg
    echo "block = $DEV_BLOCK">> $NH_DEVDIR/devices.cfg
fi

if [[ -f "kernel/arch/arm/boot/zImage" ]]; then
    echo "[CONFIGURE] Copying created kernel to Kali Installer kernels directory..."
    mkdir -p "$NH_DEVDIR/$KERN_ANDROIDVER/$KALI_DEVNAME"
    cp -f "kernel/arch/arm/boot/zImage" "$NH_DEVDIR/$KERN_ANDROIDVER/$KALI_DEVNAME/zImage"
fi

echo "[BUILD] Building Kali Nethunter package..."
sleep 2

if [[ ! -f "kali-nethunter/nethunter-installer/common/tools/freespace.sh.backup" ]]; then
    echo "[BUILD] Backing up freespace.sh..."
    mv "kali-nethunter/nethunter-installer/common/tools/freespace.sh" "kali-nethunter/nethunter-installer/common/tools/freespace.sh.backup"
    echo "[BUILD] Replacing freespace.sh..."
    echo -e '#!/bin/bash\nexit 0' > "kali-nethunter/nethunter-installer/common/tools/freespace.sh"
fi
echo "[INFO] Changing directory to 'kali-nethunter/nethunter-installer'..."
cd "kali-nethunter/nethunter-installer/"
echo "[BUILD] Building the Kali NH package..."
python build.py -d $KALI_DEVNAME --$KERN_ANDROIDVER
echo "[INFO] Python script called. Cleaning up..."
echo "Original hostname: $ORIGINALHOSTNAME"

echo "[CONFIGURE] Restoring system host name to '"$ORIGINALHOSTNAME"'..."
export HOSTNAME=$ORIGINALHOSTNAME
sudo hostname "$ORIGINALHOSTNAME"
echo "OK"
echo "[DONE] Compilation complete."
