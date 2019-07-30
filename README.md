# Kali Nethunter for the HTC One M7 GPE.
![Kali NetHunter](https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/raw/master/images/nethunter-git-logo.png)
HTC One M7, with magic.

It's a completely stock kernel but it has already had the 802.11 patch applied and has had its configuration changed so that it loads drivers for the Atheros and Realtek WiFi chipsets. It also has RTL SDR, external Bluetooth and Ethernet drivers - basically the things you'd expect.

A working keyboard gadget patch has also been applied, thanks to @binkybear and @tjado

# Kernel sources.

Source code for the modified kernel(s) can be found [here](https://github.com/lavanoid/android_kernel_htc_m7gpe)

Currently the only supported version is 5.1 Lollipop Google Play Edition, though there may be support for other ROMs in the future.

* 5.1 Lollipop GPE branch: [link](https://github.com/lavanoid/android_kernel_htc_m7gpe/tree/android-5.1)

# Compiling.

This cannot be compiled on Windows. I recommend using either Ubuntu 15 64bit or Arch/Manjaro 64bit. The script will automatically download the required dependencies, assuming that you are using a Debian-based or Arch-based Linux distro (such as Ubuntu, Manjaro etc). The script can be adapted to work with other devices.

    bash ./build.sh

By default the script uses 2 cores for compiling the source code, but it does check to see if any more cores are available to use. If it succeeds, it will adapt itself to utilise them, making the build process faster.

If the script is ran successfully, you should have an installer zip file that will allow you to flash Kali Nethunter onto your device through the recovery menu (TWRP is recommended). To find out where the installer is located, use your eyes and the terminal output should tell you where it is.

 I DO NOT provide any means of technical support and neither do I take responsibility for whatever the outcome that may occur when you fiddle around with this and your device.
