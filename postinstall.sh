#!/bin/bash


#please note that this script is very dirty and still very much
in-progress. Totally disorganized and mostly untested. At this point,
it has Fedora 23 XFCE in mind, but you
will still see some deprecated commands (like yum install instead of
dnf install". The whole purpose of this script is for me to be able to
quickly deploy a Fedora 23 desktop system that is customized to my
liking. Why am I not doing this with Kickstart you ask? Well, I have
had mixed experiencecs with kickstart when it comes to installing
packages. The installation often hangs, or the package will be listed
as "not available". In time, this script may be better integrated as a
true kickstart postinstall script, but for now, I plan on simply
firing up a recently imaged computer and then execute this script. I
will use kickstart for the basics alone (I have a simple kickstart
file that will partition my disks and create users.)




#THE FOLLOWING IS A SECTION FOR IDEAS AND TODO----
#-------------------------------------------------
#
#Maybe set the desired options for log files, such as the 
#yum log? Maybe cat any yum install commands used into a special
#section of this script for future installation?
#
#need to autoconfig xchat sounds, connect to znc, etc.
#need to bring over .bashrc
#need to bring over .vimrc
#need to bring over my own bash scripts and place them into their proper spot
#need to properly set up yumlog monitoring
#need to install ssh
#need to change /etc/ssh/sshd_config to enable password and set port
#need to chkconfig sshd on and service sshd start
#need to open the port via firewall
#need to paste in asciiart greeting for ssh
#add me to the sudoers file

#yum install -y https://github.com/fastrizwaan/fedora-rizvan/raw/master/fedora-rizvan-repo-1.0-2.noarch.rpm
#yum -y install simplescreenrecorder
#yum -y install devede
#yum -y install dvdstyler
yum -y install screenfetch
yum -y install vlc
yum -y install unzip


#I would like to set up some sort of log rotation scheme and upload logs to homeserver.

#need to figure out how to use docker

#-------------------------------------------------
#END OF IDEAS AND TODO SECTION


#------------------------SECTION-FOR-VARIABLES----------------------------------

MYUSER=donnie
INSTALLMETHOD="yum -y"



#--------------------END-OF-SECTION-FOR-VARIBALES-------------------------------



#yum -y update

#cd ~

##the first thing we need to do is set up our repos

#echo "installing repos"

#echo "installing rpmfusion repos"

#yum -y localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

#yum -y localinstall --nogpgcheck http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#echo "rpmfusion repos installation complete"



#---------------------------SET-HOSTNAME----------------------------------------

hostnamectl set-hostname --static "fed23laptop"

#-------------------------END-SET-HOSTNAME--------------------------------------


#------------------------INSTALL-GOOGLE-CHROME----------------------------------

touch /etc/yum.repos.d/google-chrome.repo

chmod 2777 /etc/yum.repos.d/google-chrome.repo

cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=0
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

echo "google chrome repo install complete"

yum -y install google-chrome-stable

echo "google chrome installed"

#---------------------END-INSTALL-GOOGLE-CHROME---------------------------------

#--------------------------INSTALL-STEAM----------------------------------------

dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo

dnf -y install steam

#------------------------END-INSTALL-STEAM--------------------------------------

#--------------------------INSTALL INSYNC---------------------------------------

touch /etc/yum.repos.d/insync.repo

cat << EOF > /etc/yum.repos.d/insync.repo
[insync]
name=insync repo
baseurl=http://yum.insynchq.com/fedora/$releasever/
enabled=1
gpgcheck=0
EOF

yum -y install insync

#------------------------END-INSTALL-INSYNC-------------------------------------



#------------------------INSTALL-VIRTUALBOX-------------------------------------

cd /etc/yum.repos.d/

wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo

dnf install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms

dnf install VirtualBox-5.0

/usr/lib/virtualbox/vboxdrv.sh setup

usermod -a -G vboxusers $MYUSER

#----------------------END-INSTALL-VIRTUALBOX-----------------------------------

#----------------------INSTALL-PYTHON-PYCHARM-----------------------------------

yum -y install python
#need to store pycharm community rpm

#--------------------END-INSTALL-PYTHON-PYCHARM---------------------------------

#----------------------INSTALL-Auth/pubtools-----------------------------------

yum -y groupinstall "Authoring and Publishing"

#----------------------END-INSTALL-Auth/pubtools--------------------------------



#--------------------INSTALL-JAVA-and-Eclipse-----------------------------------


#see http://www.if-not-true-then-false.com/2014/install-oracle-java-8-on-fedora-centos-rhel/


#dnf -y install eclipse-platform

#need to manually download and configure aptana plugin
 
#----------------END-INSTALL-JAVA-and-Eclipse-----------------------------------


cd /home/donnie/Downloads/
wget http://37.187.115.107/fedora/23/x86_64/Packages/t/terminus-fonts-4.39-2.fc23.noarch.rpm
dnf -y install terminus-fonts-4.39-2.fc23.noarch.rpm

##Now for the rest

yum -y install rxvt
yum -y install terminator
yum -y install devilspie

##need logic here to make sure that the config file is present

#decided to comment out terminator setup for desktop-integrated terminal. going with roxterm instead.

#cat << EOF > /home/donnie/.config/terminator
#[global_config]
#[keybindings]
#[profiles]
#  [[default]]
#    background_image = None
#    foreground_color = "#f7fb1b"
#  [[devil]]
#    scrollbar_position = hidden
#    palette = "#c403f1:#aa0000:#00aa00:#aa5500:#4169e1:#aa00aa:#00aaaa:#aaaaaa:#c0bebf:#ff5555:#55ff55:#ffff55:#8585da:#ff55ff:#55ffff:#ffffff"
#    exit_action = restart
#    background_darkness = 0.92
#    background_type = transparent
#    background_image = None
#    foreground_color = "#f8ff00"
#    show_titlebar = False
#    background_color = "#0f0c03"
#    scrollback_infinite = True
#[layouts]
#  [[default]]
#    [[[child1]]]
#      type = Terminal
#      parent = window0
#      profile = default
#      
#EOF

mkdir /home/donnie/.devilspie/
mkdir /home/donnie/.devilspie/DesktopConsole.ds
chown donnie /home/donnie/.devilspie/DesktopConsole.ds
cat << EOF > /home/donnie/.devilspie/DesktopConsole.ds
(if
        (matches (window_name) "DesktopConsole")
        (begin
                (unpin)
                (below)
    	(undecorate)
                (skip_pager)
                (center)
                (skip_tasklist)
		(geometry "+112+140")
                (wintype "utility")
        )
)
EOF

#this will not work: need to manually create the files.

cat << EOF > /home/donnie/.config/roxterm.sourceforge.net/Global
[roxterm options]
warn_close=3
only_warn_running=1
profile=DesktopConsole
encoding=UTF-8
prefer_dark_theme=1
EOF

mkdir /home/donnie/.config/roxterm.sourceforge.net/Profiles/DesktopConsole
touch /home/donnie/.config/roxterm.sourceforge.net/Profiles/DesktopConsole
chown donnie /home/donnie/.config/roxterm.sourceforge.net/Profiles/DesktopConsole

cat << EOF > /home/donnie/.config/roxterm.sourceforge.net/Profiles/DesktopConsole
[roxterm profile]
font=Terminus 10
always_show_tabs=0
hide_menubar=1
show_add_tab_btn=0
saturation=0.000000
win_title=DesktopConsole
audible_bell=0
bell_highlights_tab=0
exit_action=1
scrollbar_pos=0
disable_menu_access=1
disable_menu_shortcuts=1
disable_tab_menu_shortcuts=1
show_tab_num=0
tab_close_btn=0
tab_pos=4
colour_scheme=GTK
width=100
height=30
EOF

mkdir /home/donnie/.config/autostart/
cd /home/donnie/.config/autostart/
touch /home/donnie/.config/autostart/devil.desktop
chown donnie /home/donnie/.config/autostart/devil.desktop
cat << EOF > /home/donnie/.config/autostart/devil.desktop
[Desktop Entry]
Name=devil
GenericName=devil
Comment=Start these up at login
Exec=/home/donnie/.config/autostart/devil.sh
Terminal=False
Type=Application
X-GNOME-Autostart-enabled=true
EOF

touch /home/donnie/.config/autostart/devil.sh
chown donnie /home/donnie/.config/autostart/devil.sh
chmod 2777 /home/donnie/.config/autostart/devil.sh
cat << EOF > /home/donnie/.config/autostart/devil.sh
#!/bin/bash
roxterm --profile=DesktopConsole --hide-menubar --title=DesktopConsole --role=borderless
EOF

#install git

yum -y install git

#install tools

yum -y install vim 
yum -y install tmux


#clone dotfiles repo

cd /home/donnie/
git clone git://github.com/dchardin/dotfiles.git
cd /home/donnie/dotfiles
chmod 2777 makesymlinks.sh
./makesymlinks.sh




yum -y install xchat
yum -y install openssh
yum -y install git
yum -y install xfreerdp
yum -y install expect
yum -y install sound-juicer
yum install -y mercurial pytz python-urllib2_kerberos python-argparse
yum -y install openvpn
yum -y install autokey-gtk

yum -y install libdvdcss libdvdread libdvdnav lsdvd libdvbpsi gstreamer gstreamer-ffmpeg gstreamer-plugins-bad gstreamer-plugins-bad-free gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree gstreamer-plugins-base gstreamer-plugins-good gstreamer-plugins-ugly k3b-extras-freeworld xine-lib xine-lib-extras xine-lib-extras-freeworld
yum -y install gstreamer gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly

yum -y install gnupg
yum -y install evince
yum -y install byzanz
yum -y install nmap
yum -y install htop
yum -y install atop
yum -y install dos2unix





