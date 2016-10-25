# Kali Nethunter for the HTC One M7 GPE.
![Kali NetHunter](https://raw.githubusercontent.com/offensive-security/kali-nethunter/master/images/nethunter-git-logo.png)
Stock 5.1 kernel for the HTC One GPE, with magic.

It's a completely stock kernel but it has already had the 802.11 patch applied and has had its configuration changed so that it loads drivers for the Atheros and Realtek WiFi chipsets. It also has RTL SDR, external Bluetooth and Ethernet drivers - basically the things you'd expect.

A working keyboard gadget patch has also been applied, thanks to @binkybear and @tjado

#Compiling.

This cannot be compiled on Windows. I recommend using Ubuntu 15 64BIT. The script will automatically download the required dependencies, assuming that you are using a Debian-Based Linux Disto (such as Ubuntu). The script can be adapted to work with other devices.

    bash ./build.sh

By default the script uses 2 cores for compiling the source code, but it does check to see if any more cores are available to use. If it succeeds, it will adapt itself to utilise them, making the build process faster.

If the script is ran successfully, you should have an installer zip file that will allow you to flash Kali Nethunter onto your device through the recovery menu (TWRP is recommended). To find out where the installer is located, use your eyes and the terminal output should tell you where it is.

 I DO NOT provide any means of technical support and neither do I take responsibility for whatever the outcome that may occur when you fiddle around with this and your device.
