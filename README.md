# OneM7GPE5.1_KaliKernel
Stock 5.1 kernel for the HTC One GPE, with magic.

It's a completely stock kernel but it has already had the 802.11 patch applied and has had its configuration changed so that it loads drivers for the Atheros and Realtek WiFi chipsets. It also has RTL SDR, external Bluetooth and Ethernet drivers - basically the things you'd expect.

This kernel does not support HID mouse/keyboard emulation though it would be nice if it were somehow implemented. Thank you BlinkyBear for your efforts! :D

#Compiling.

This cannot be compiled on Windows. I recommend using Ubuntu 15 64BIT

    bash ./build.sh

By default the script uses 4 cores for compiling the source code but you can edit it to use more or less. Edit the line with `make -j4`



