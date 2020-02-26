### RPi/Odroid Setup:


- Change password:  
```sudo passwd username```
- Change hostname:  
```sudo hostnamectl set-hostname newhostname```
- Update/Upgrade system:  
```sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade```
- Install dev stuff:  
```sudo apt-get install git build-essential cmake libusb-1.0-0-dev pkg-config libfftw3-dev```
- Force reinstall of mali-x11:  
```sudo apt-get install --reinstall mali-x11```
- Install Wireshark:  
```sudo add-apt-repository ppa:wireshark-dev/stable```  
```sudo apt-get install wireshark tshark```
- Download Processing:  
```wget -qO- http://download.processing.org/processing-3.5.3-linux-armv6hf.tgz | tar -xvz```
- sudo without password:  
```sudo EDITOR=nano visudo```  
```username ALL=(ALL) NOPASSWD:ALL```
- Automatic login:  
```nano /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf```
```
[SeatDefaults]
greeter-session=lightdm-gtk-greeter
autologin-user=srackham
```
- Enable portrait mode:  
```nano /etc/X11/xorg.conf```  
\- ~~```Driver "armsoc"```~~  
\+ ```Driver "fbdev"```
- Portrait mode on login:  
```nano ~/.config/autostart/portrait.desktop```
```
[Desktop Entry]
Type=Application
Exec=/home/username/algotypes/scripts/portrait.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_NG]=Portrait
Name=Portrait
Comment[en_NG]=
Comment=
```
- Wireshark on login:  
```nano ~/.config/autostart/tshark.desktop```
```
[Desktop Entry]
Type=Application
Exec=mate-terminal --full-screen -e 'bash -c "sudo /home/username/algotypes/scripts/tshark.sh; bash"'
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_NG]=Portrait
Name=Portrait
Comment[en_NG]=
Comment=
```
- Enable gpu-composite window manager:  
```gsettings set org.mate.session.required-components windowmanager marco-compton```
- Change default terminal profile colors/transparency:  
```dconf write /org/mate/terminal/profiles/default/background-color "'#000000000000'"```  
```dconf write /org/mate/terminal/profiles/default/foreground-color "'#FFFFFFFFFFFF'"```  
```dconf write /org/mate/terminal/profiles/default/background-type "'transparent'"```  
```dconf write /org/mate/terminal/profiles/default/background-darkness "0.0"```  
```dconf write /org/mate/terminal/profiles/default/scrollbar-position "'hidden'"```
- Change desktop background:  
```gsettings set org.mate.background picture-filename ''```  
```gsettings set org.mate.background primary-color '#000'```  
```gsettings set org.mate.background color-shading-type 'solid'```
- Restart desktop:  
```sudo /etc/init.d/lightdm restart```
