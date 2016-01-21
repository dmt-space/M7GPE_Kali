# OneM7GPE5.1_KaliKernel
Stock 5.1 kernel for the HTC One GPE, with magic.

It's a completely stock kernel but it has already had the 802.11 patch applied and has had its configuration changed so that it loads drivers for the Atheros WiFi chipsets.


In the AnyKernel2 devices.cfg, the onem7 is added as following:

#HTCOneM7GPE
[onem7]
devicenames = m7
block = /dev/block/platform/msm_sdcc.1/by-name/boot
aroma = True


