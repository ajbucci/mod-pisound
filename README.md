##### [MOD Devices](https://moddevices.com/) software install script for Raspberry OS 64bit with [PiSound hat](https://blokas.io/pisound/) from Blokas Labs
*** 
_use at your own risk!_ _still not widely tested and unsafe_

to install make sure to run setUsername first. This will replace the username in the scripts with your raspberry $USER

```sh setUsername.sh```

```sh install.sh```

your user must be added to a group called audio and other perks explained in the [Linux Audio Wiki](https://wiki.linuxaudio.org/wiki/system_configuration) for best performance


This is an modification from the original repo to work with PiSound hat and some other changes to make it work good on a fresh raspberry pi

The audio settings are in jack.service where you can change the buffer size, sample rate etc.

Plugins must be compiled by you either using the [MOD plugin builder](https://github.com/moddevices/mod-plugin-builder)
or manually compile any lv2 that you wish and create a mod GUI for it using [MOD sdk](https://github.com/moddevices/mod-sdk)

The setup allows to use MOD software alongside other programs like sequencers, plugin hosts or other daws and route the audio at will using any jack patching tool


 [More details](https://forum.moddevices.com/t/raspberry-pi-4-setup-getting-crazy-with-jack/7691)

 If you want to overclock your pi to 1.8 GHz instead of the default 1.5 GHz consider using a fan or other means of cooling, things can warm up to 80ºC!
 You do so by adding ```arm_boost=1``` in your ```/boot/config.txt``` 