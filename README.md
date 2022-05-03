##### [MOD Devices](https://moddevices.com/) software install script for RaspiOS Lite 64bit Bullseye with [PiSound hat](https://blokas.io/pisound/)



to install make sure to run setUsername first
```sh setUsername.sh```

```sh install.sh```

 needs testing 

 In the current tested scenarios , mod is functional but requires manually routing the audio from the last effect in the chain to the jack port via terminal tools or GUI tools like Carla , Catia patchage etc
 Till someone finds a way to make fix mod-ui service to start from a user spawned service (now it does not for some reason ) [details](https://forum.moddevices.com/t/raspberry-pi-4-setup-getting-crazy-with-jack/7691)