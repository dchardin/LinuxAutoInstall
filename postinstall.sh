#!/bin/bash
#===============================================================================
# LINUX AUTO INSTALL
# By dchardin <donnie@fedoraproject.org>
#
# Please note that this script is very dirty and still very much in-progress.
# 
# Totally disorganized and mostly untested. At this point, it has Fedora 23
# XFCE in mind, but you will still see some deprecated commands (like yum
# install instead of dnf install". The whole purpose of this script is for me
# to be able to quickly deploy a Fedora 23 desktop system that is customized to
# my liking. Why am I not doing this with Kickstart you ask? Well, I have had
# mixed experiencecs with kickstart when it comes to installing packages. The
# installation often hangs, or the package will be listed as "not available".
# In time, this script may be better integrated as a true kickstart postinstall
# script, but for now, I plan on simply firing up a recently imaged computer
# and then execute this script. I will use kickstart for the basics alone (I
# have a simple kickstart file that will partition my disks and create users.)
#===============================================================================

#-------------------------------------------------------------------------------
# TODO
#
# Maybe set the desired options for log files, such as the #yum log? Maybe cat
# any yum install commands used into a special #section of this script for
# future installation?
#
# - need to autoconfig xchat sounds, connect to znc, etc.
# - need to bring over .bashrc
# - need to bring over .vimrc
# - need to bring over my own bash scripts and place them into their proper spot
# - need to properly set up yumlog monitoring
# - need to install ssh
# - need to change /etc/ssh/sshd_config to enable password and set port
# - need to chkconfig sshd on and service sshd start
# - need to open the port via firewall
# - need to paste in asciiart greeting for ssh
# - add me to the sudoers file
# - need to come up with a conky config
# - I would like to set up some sort of log rotation scheme and upload logs to
#   homeserver.
# - need to figure out issue with docker
# - need to decide on the method I want to use for gitcloning my dotfiles which
#   will include my .vimrc
# - need to decide if I am going to add in the vundle .vimrc lines fresh, or
#   have them in my .vimrc that is hosted on gihub beforehand
# - come up with a way to capture the entire output of all dnf and 
# - yum installs, and save to files.
# - add weechat configs with connect to znc
# - add rename.pl to augment rename 
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# VARIABLES
#-------------------------------------------------------------------------------
MYUSER=donnie
INSTALLMETHOD="yum -y"
GITHUBID=dchardin
GITHUBEMAIL=dch84121@gmail.com

#-------------------------------------------------------------------------------
# YUM Repos
#-------------------------------------------------------------------------------


# For all of these localinstall commands, need to use variable. DNF cannot be 
# called to perform in this fashion.

#yum -y localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm


#yum -y localinstall --nogpgcheck http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Add Chrome
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

# Add Insync Repo
touch /etc/yum.repos.d/insync.repo
cat << EOF > /etc/yum.repos.d/insync.repo
[insync]
name=insync repo
baseurl=http://yum.insynchq.com/fedora/$releasever/
enabled=1
gpgcheck=0
EOF

# Add Steam Repo
dnf config-manager --add-repo=http://negativo17.org/repos/fedora-steam.repo

# Add Virtualbox Repo
cd /etc/yum.repos.d/
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo


##this one is dead

# Add rizvan repo
yum install -y https://github.com/fastrizwaan/fedora-rizvan/raw/master/fedora-rizvan-repo-1.0-2.noarch.rpm

#Add Docker

touch /etc/yum.repos.d/docker.repo
cat << EOF > /etc/yum.repos.d/docker.repo
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/fedora/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF


#Add Adobe for flash support

rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux


touch /etc/yum.repos.d/opera.repo
cat << EOF > /etc/yum.repos.d/opera.repo
[opera]
name=Opera packages
type=rpm-md
baseurl=https://rpm.opera.com/rpm
gpgcheck=1
gpgkey=https://rpm.opera.com/rpmrepo.key
enabled=1
EOF

dnf -y install opera-developer








#-------------------------------------------------------------------------------
# YUM Install
#-------------------------------------------------------------------------------

# going to have to look at how these newlines are being done. package names are
# globbing together. Also having trouble finding libdvbcss and
# simplescreenrecorder

yum -y update
yum -y groupinstall  'Authoring and Publishing' 'Development Tools'
yum -y install atop autokey-gtk automake binutils byzanz bzip2-devel cmake curl\
curl-devel devilspie dkms dos2unix evince expat-devel expect gcc gcc-c++ git\
glibc-devel glibc-headers gnupg golang google-chrome-stable gstreamer\
gstreamer-ffmpeg gstreamer-plugins-bad gstreamer-plugins-bad-free\
gstreamer-plugins-bad-free-extras gstreamer-plugins-bad-nonfree\
gstreamer-plugins-base gstreamer-plugins-good gstreamer-plugins-ugly htop\
insync k3b-extras-freeworld kernel-devel kernel-headers libdvbpsi libdvdcss\
libdvdnav libdvdread libgomp lsdvd m4 make mercurial ncurses-devel nmap openssh\
openvpn patch python-argparse python-devel python-urllib2_kerberos pytz ruby\
rxvt screenfetch sound-juicer steam terminator texinfo tmux unzip vim\
VirtualBox-5.0 vlc xchat xfreerdp xine-lib xine-lib-extras\
xine-lib-extras-freeworld zlib-devel unzip vlc screenfetch dvdstyler devede\
simplescreenrecorder 
yum -y update

dnf -y install qt5-qtbase qt5-qtbase-devel qt5-qtdeclarative qt5-qtdeclarative-devel qt5-qtgraphicaleffects qt5-qtquickcontrols redhat-rpm-config

dnf install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl

dnf install gpick

#-------------------------------------------------------------------------------
#Git and Github config
#-------------------------------------------------------------------------------

su - $MYUSER
git config --global user.name "$GITHUBID"
git config --global user.email "$GITHUBEMAIL"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

#-------------------------------------------------------------------------------
#DOCKER
#-------------------------------------------------------------------------------
dnf -y install docker-engine
systemctl enable docker
usermod -aG docker donnie



#-------------------------------------------------------------------------------
#LOOK AND FEEL
#-------------------------------------------------------------------------------
su - donnie
mkdir /home/donnie/GIT
cd /home/donnie/GIT
git clone https://github.com/dchardin/AppPacksAndMore.git
su -
cd /home/donnie/GIT/AppPacksAndMore
mkdir /usr/share/backgrounds/wallpapers
mv wallpapers.tar /usr/share/backgrounds/wallpapers
cd /usr/share/backgrounds/wallpapers
tar -xvf wallpapers.tar
mv /usr/share/backgrounds/default.png /usr/share/backgrounds/default.png.old
mv /usr/share/backgrounds/wallpapers/2015-10-22_00012.jpg ../default.png

# at this time, you need to open up applications/settings/desktop
# and set your desktop folder to /usr/share/wallpapers. Set the 
# background to change every 10 min or so.
# Then click the MENU tab, uncheck "show applicatoin icons in menu
# Then on ICON tab, select icon type None.







#-------------------------------------------------------------------------------
# LANGUAGE SUPPORT
#-------------------------------------------------------------------------------
# Go
mkdir /home/donnie/goworkspace
echo 'export GOPATH="home/donnie/goworkspace"' >> ~/.bashrc
source ~/.bashrc
# Javascript
http://blog.teamtreehouse.com/install-node-js-npm-linux'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
brew install node
npm install -g typescript
# Rust
curl -sSf https://static.rust-lang.org/rustup.sh | sh
#-------------------------------------------------------------------------------
# VIM SETUP
#-------------------------------------------------------------------------------
# get vundle for plugin management
git clone https://github.com/VundleVim/Vundle.vim.git /home/donnie/.vim/bundle
vim +PluginInstall +qall
cd .vim/bundle/YouCompleteMe/
./install.py --clang-completer --omnisharp-completer --gocode-completer     --tern-completer --racer-completer






#----------------------GET_MY_VIMRC_AND_SETUP______________________________


#get vundle for plugin management
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#need to decide if I am going to add in the vundle .vimrc lines fresh, or
#have them in my .vimrc that is hosted on gihub beforehand

#--------------------------CONFIGURE_VIM_AND_PLUGINS----------------------------

git clone https://github.com/VundleVim/Vundle.vim.git /home/donnie/.vim/bundle

#need to make sure vimrc has the required entries for vundle before bringing it over. 

#May just want to spit out instructions to do the rest manually.

vim +PluginInstall +qall


dnf -y install automake gcc gcc-c++ kernel-devel cmake

dnf -y install python-devel

yum -y install golang

mkdir /home/donnie/goworkspace
echo 'export GOPATH="home/donnie/goworkspace"' >> ~/.bashrc
source ~/.bashrc 

http://blog.teamtreehouse.com/install-node-js-npm-linux'

sudo yum groupinstall 'Development Tools' && sudo yum install curl git m4 ruby texinfo bzip2-devel curl-devel expat-devel ncurses-devel zlib-devel

"at this point, need to become donnie"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

brew install node

npm install -g typescript

curl -sSf https://static.rust-lang.org/rustup.sh | sh

cd .vim/bundle/YouCompleteMe/

./install.py --clang-completer --omnisharp-completer --gocode-completer     --tern-completer --racer-completer

#####VIM PLUGINS THAT WILL NEED TO BE INSTALLED

'scrooloose/syntastic'
'bling/vim-airline'
'SirVer/ultisnips'
'edsono/vim-matchit'
'elzr/vim-json'
'honza/vim-snippets'
'justinmk/vim-sneak'
'kien/ctrlp.vim'
'ludovicchabant/vim-lawrencium'
'majutsushi/tagbar'
'mhinz/vim-signify'
'plasticboy/vim-markdown'
'scrooloose/nerdcommenter'
'sjl/gundo.vim'
'tpope/vim-fugitive'
'tpope/vim-sleuth'
'tpope/vim-surround'
'tryu/open-browser.vim'
'vim-scripts/a.vim'
'tomasr/molokai'
'flazz/vim-colorschemes'
'SQLComplete.vim'
'dbext.vim'




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


#NOTE: Since github has a filesize limitation and jdk-8u91-linux-x64.rpm exceeds
#it, you will need to manually download the rpm first. Place it in /root/

#need to write in some logic to have it retry if exit status 1


cd /root/

dnf -y install jdk-8u91-linux-x64.rpm


#4a. Install Sun/Oracle JDK java, javaws, libjavaplugin.so (for Firefox/Mozilla) and javac with alternatives –install command
#Use Java JDK latest version (/usr/java/latest)


## java ##
alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000
## javaws ##
alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000

## Java Browser (Mozilla) Plugin 32-bit ##
#alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/latest/jre/lib/i386/libnpjp2.so 200000

## Java Browser (Mozilla) Plugin 64-bit ##
alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/latest/jre/lib/amd64/libnpjp2.so 200000

## Install javac only if you installed JDK (Java Development Kit) package ##
alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000


#Use Java JDK 8u91 absolute version (/usr/java/jdk1.8.0_91)


## java ##
alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_91/jre/bin/java 200000
## javaws ##
alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.8.0_91/jre/bin/javaws 200000

## Java Browser (Mozilla) Plugin 32-bit ##
#alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/jdk1.8.0_91/jre/lib/i386/libnpjp2.so 200000

## Java Browser (Mozilla) Plugin 64-bit ##
alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/jdk1.8.0_91/jre/lib/amd64/libnpjp2.so 200000

## Install javac only if you installed JDK (Java Development Kit) package ##
alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_91/bin/javac 200000
alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_91/bin/jar 200000


#4b. Install Sun/Oracle JRE java, javaws and libjavaplugin.so (for Firefox/Mozilla) with alternatives –install command
#Use Java JRE latest version (/usr/java/latest)

## java ##
alternatives --install /usr/bin/java java /usr/java/latest/bin/java 200000
 
## javaws ##
alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
 
## Java Browser (Mozilla) Plugin 32-bit ##
#alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/latest/lib/i386/libnpjp2.so 200000
 
## Java Browser (Mozilla) Plugin 64-bit ##
alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/latest/lib/amd64/libnpjp2.so 200000
 

#Use Java JRE 8u91 absolute version (/usr/java/jre1.8.0_91)

## java ##
alternatives --install /usr/bin/java java /usr/java/jre1.8.0_91/bin/java 200000

## javaws ##
alternatives --install /usr/bin/javaws javaws /usr/java/jre1.8.0_91/bin/javaws 200000

## Java Browser (Mozilla) Plugin 32-bit ##
#alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so libjavaplugin.so /usr/java/jre1.8.0_91/lib/i386/libnpjp2.so 200000

## Java Browser (Mozilla) Plugin 64-bit ##
alternatives --install /usr/lib64/mozilla/plugins/libjavaplugin.so libjavaplugin.so.x86_64 /usr/java/jre1.8.0_91/lib/amd64/libnpjp2.so 200000


echo "Java Install Complete. Use java -version and javaac version to see details. Use alternatives --config [ java | javaws | libjavaplugin.so.x86_64 | javac | ] to swap components in and out."

#postinstallation setup java

#Java JDK and JRE latest version (/usr/java/latest)
 
## export JAVA_HOME JDK/JRE ##
export JAVA_HOME="/usr/java/latest"

#Java JDK and JRE absolute version (/usr/java/jdk1.8.0_91)
## export JAVA_HOME JDK ##
export JAVA_HOME="/usr/java/jdk1.8.0_91"
 
## export JAVA_HOME JRE ##
export JAVA_HOME="/usr/java/jre1.8.0_91"




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
touch /home/donnie/.devilspie/DesktopConsole.ds
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


mkdir /home/donnie/.config/roxterm.sourceforge.net
touch /home/donnie/.config/roxterm.sourceforge.net/Global
chown donnie /home/donnie/.config/roxterm.sourceforge.net/Global

cat << EOF > /home/donnie/.config/roxterm.sourceforge.net/Global
[roxterm options]
warn_close=3
only_warn_running=1
profile=DesktopConsole
encoding=UTF-8
prefer_dark_theme=1
EOF

#need to insert logic to check if directory already exists


mkdir /home/donnie/.config/roxterm.sourceforge.net/Profiles
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

#Need to add in logic to check if directory already exists

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
devilspie & roxterm --profile=DesktopConsole --hide-menubar --title=DesktopConsole --role=borderless
EOF


touch /home/donnie/.config/autostart/clearsessions.sh
chown donnie /home/donnie/.config/autostart/clearsessions.sh
chmod 2777 /home/donnie/.config/autostart/clearsessions.sh
cat << EOF > /home/donnie/.config/autostart/clearsessions.sh
#!/bin/bash
rm -rf /home/*/.cache/sessions/*
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





