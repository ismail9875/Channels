#!/bin/sh

#configuration
echo """
##########################################################################
# ********************************************************************** #
# ***  Thanks my brother Haitham Sudani for the installation script  *** #
# ********************************************************************** #
##########################################################################
"""
sleep 3 
#######################################
channel="channels_backup_Ismail9875-motor-30w-42E.tar.gz"
url="https://github.com/ismail9875/Channels/raw/refs/heads/main/motor/"

# Remove unnecessary files and folders
#######################################
[ -d "/CONTROL" ] && rm -r /CONTROL >/dev/null 2>&1
rm -rf /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1


# downloading channels lists file
#######################################
echo ">>> Downloading "$channel" Channels Lists  Please Wait ... <<<"
sleep 3
wget --show-progress ${url}/${channel}.tar.gz -qP /tmp

#removing old channels lists file
#######################################
rm -rf /etc/enigma2/lamedb /etc/enigma2/*list /etc/enigma2/*.tv /etc/enigma2/*.radio  /etc/tuxbox/*.xml >/dev/null 2>&1

#extracting channels lists file
#######################################
cd /tmp
set -e
sleep 3
echo
tar -xzf $channel.tar.gz -C /
set +e
rm -f $channel.tar.gz

# Restart Enigma2 service or kill enigma2 based on the system
#######################################
if [ -f /etc/opkg/opkg.conf ];then
echo
echo "> "$channel" Channels Lists are installed successfully"
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 2
echo
# Installing astra-sm 
echo """
>>> Installing astra-sm & Configs fils, please wait <<<
"""
wget -q --show-progress "--no-check-certificate" https://gitlab.com/eliesat/softcams/-/raw/main/astra-sm/astra-sm-arm-0.2-r0.sh -O - | /bin/sh
reboot
else
echo
sleep 2

echo "> your device will restart now, please wait..."
systemctl restart enigma2
fi
