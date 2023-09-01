#!/bin/bash -e

set -x
#Install Dependancies
sudo apt-get -y install virtualenv python3-pip python3-dev build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev \
                        zlib1g-dev cmake debhelper dh-autoreconf dh-python gperf intltool ladspa-sdk libarmadillo-dev libavahi-gobject-dev \
                        libavcodec-dev libavutil-dev libbluetooth-dev libboost-dev libeigen3-dev libfftw3-dev libglib2.0-dev libglibmm-2.4-dev \
                        libgtk2.0-dev libgtkmm-2.4-dev liblrdf0-dev libsamplerate0-dev libsigc++-2.0-dev libsndfile1-dev libzita-convolver-dev \
                        libzita-resampler-dev lv2-dev p7zip-full python3-all python3-setuptools libreadline-dev zita-alsa-pcmi-utils hostapd \
                        dnsmasq iptables python3-smbus liblo-dev python3-liblo libzita-alsa-pcmi-dev authbind rcconf libfluidsynth-dev lockfile-progs

#Install Python Dependancies
sudo pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11 scandir backports.shutil-get-terminal-size
sudo pip3 install pycrypto
sudo pip3 install tornado==4.3
sudo pip3 install Pillow==8.4.0
sudo pip3 install cython

#Install Mod Software
mkdir /home/${USER}/.lv2
mkdir /home/${USER}/data
mkdir /home/${USER}/data/.pedalboards
mkdir /home/${USER}/data/user-files
cd /home/${USER}/data/user-files
mkdir "Speaker Cabinets IRs"
mkdir "Reverb IRs"
mkdir "Audio Loops"
mkdir "Audio Recordings"
mkdir "Audio Samples"
mkdir "Audio Tracks"
mkdir "MIDI Clips"
mkdir "MIDI Songs"
mkdir "Hydrogen Drumkits"
mkdir "SF2 Instruments"
mkdir "SFZ Instruments"
mkdir "Amplifier Profiles"
mkdir "Aida DSP Models"

#jackd2
pushd $(mktemp -d) && git clone https://github.com/moddevices/jack2.git
pushd jack2
./waf configure
./waf build
sudo ./waf install

#Browsepy
pushd $(mktemp -d) && git clone https://github.com/micahvdm/browsepy
pushd browsepy
sudo pip3 install ./

#Mod-host
pushd $(mktemp -d) && git clone https://github.com/moddevices/mod-host.git
pushd mod-host
make -j 4
sudo make install

#Mod-ui
pushd $(mktemp -d) && git clone  https://github.com/micahvdm/mod-ui
pushd mod-ui
chmod +x setup.py
cd utils
make
cd ..
sudo ./setup.py install
cp -r default.pedalboard /home/${USER}/data/.pedalboards/

#Touchosc2midi
pushd $(mktemp -d) && git clone https://github.com/BlokasLabs/amidithru.git
pushd amidithru
sed -i 's/CXX=g++.*/CXX=g++/' Makefile
sudo make install

pushd $(mktemp -d) && git clone https://github.com/micahvdm/touchosc2midi.git
pushd touchosc2midi
sudo pip3 install ./

pushd $(mktemp -d) && git clone https://github.com/micahvdm/mod-midi-merger.git
pushd mod-midi-merger
mkdir build && cd build
cmake ..
make
sudo make install

cd /home/${USER}

ln -s /home/${USER}/data/.pedalboards /home/${USER}/.pedalboards
ln -s /home/${USER}/.lv2 /home/${USER}/data/.lv2

cd /home/${USER}/mod-pisound

# Copy jack driver to etc
sudo cp jackdrc /etc/
sudo chmod +x /etc/jackdrc

#Create Services
cat browsepy.service.template | envsubst > browsepy.service
cat jack.service.template | envsubst > jack.service
cat mod-host.service.template | envsubst > mod-host.service
cat mod-ui.service.template | envsubst > mod-ui.service
cat mod-midi-merger.service.template | envsubst > mod-midi-merger.service
cat mod-midi-merger-broadcaster.service.template | envsubst > mod-midi-merger-broadcaster.service

#Create users and groups so services can run as user instead of root
sudo adduser --no-create-home --system --group jack
sudo adduser $USER jack --quiet
sudo adduser root jack --quiet
sudo adduser jack audio --quiet
sudo cp jackdrc /etc/
sudo chmod +x /etc/jackdrc
sudo chown jack:jack /etc/jackdrc
sudo cp 80 /etc/authbind/byport/
sudo chmod 500 /etc/authbind/byport/80
sudo chown ${USER}:${USER} /etc/authbind/byport/80

# Enable services
sudo cp *.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable browsepy.service
sudo systemctl enable jack.service
sudo systemctl enable mod-host.service 
sudo systemctl enable mod-ui.service
#sudo systemctl enable mod-amidithru.service
#sudo systemctl enable mod-touchosc2midi.service
sudo systemctl enable mod-midi-merger.service
sudo systemctl enable mod-midi-merger-broadcaster.service

#echo "@audio - rtprio 95" | sudo tee -a /etc/security/limits.conf
#echo "@audio - memlock unlimited" | sudo tee -a /etc/security/limits.conf

echo "creating /etc/environment and setting jack promiscuous mode"
echo 'JACK_PROMISCUOUS_SERVER=jack' | sudo tee -a /etc/environment

# download plugins
pushd $(mktemp -d) && wget https://www.treefallsound.com/downloads/lv2plugins.tar.gz
tar -zxf lv2plugins.tar.gz -C $HOME

#disable PWM audio
sudo bash -c "sed -i \"s/^\s*dtparam=audio/#dtparam=audio/\" /boot/config.txt"
# Remove devices not needed for audio
sudo bash -c "sed -i \"s/^\s*hdmi_force_hotplug=/#hdmi_force_hotplug=/\" /boot/config.txt"
sudo bash -c "sed -i \"s/^\s*camera_auto_detect=/#camera_auto_detect=/\" /boot/config.txt"
sudo bash -c "sed -i \"s/^\s*display_auto_detect=/#display_auto_detect=/\" /boot/config.txt"
sudo bash -c "sed -i \"s/^\s*dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/\" /boot/config.txt"

# add alsa restore to rc local
sudo patch -b -N -u /etc/rc.local -i /home/raspberryUser/mod-pisound/rclocal.diff

#echo "cleaning tmp folder"
#sudo rm -rf /tmp/*

echo "starting mod"
./startMod.sh