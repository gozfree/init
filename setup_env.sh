#!/bin/sh
# Auto Setup Environment Script

CMD=$0
ACTION=$1
SW_TYPE=$2

ppa_exist=0

minimal_list="
build-essential
curl
exfat-utils exuberant-ctags
ffmpeg
g++ git
meld
nextcloud-client
openssh-server
pkg-config ppa-purge
rar
shadowsocks-qt5 subversion synaptic
vim vlc
"


optional_list="
mplayer
dpkg-dev dput
fcitx-libs fcitx-libs-qt
gcc-mingw-w64
htop
libjansson-dev liblua5.2-dev libopencc1
nginx
python-pip python-m2crypto
"

software_list="
$minimal_list
$optional_list
"

config_list="
.gitconfig
.vimrc
.vim/
.crx/
"

ppa_list="
ppa:hzwhuang/ss-qt5
ppa:nextcloud-devs/client

"

check_ppa()
{
	item=`echo "$1" | awk -F\:  '{printf $2}' | cut -d'/' -f1`
	item_file=`find /etc/apt/sources.list.d/ | grep -v ".save" | grep ".list" | grep $item`
	ret=`egrep -v '^#|^ *$' $item_file`
	if [ "$ret" = "" ]; then
		ppa_exist=0
	else
		ppa_exist=1
	fi
}


add_ppa()
{
	echo "start to add $ppa_list..."
	for ppa_item in $ppa_list; do
		check_ppa $ppa_item
		if [ $ppa_exist -eq 1 ]; then
			echo "$ppa_item exist"
			continue
		fi
		sudo add-apt-repository -y $ppa_item
	done
	echo "add PPA finished."
}

remove_ppa()
{
	echo "start to remove $ppa_list..."
	for ppa_item in $ppa_list; do
		check_ppa $ppa_item
		if [ $ppa_exist -eq 0 ]; then
			continue
		fi
		echo "$ppa_item exist"
		sudo ppa-purge $ppa_item
	done
	echo "remove PPA finished."
}

install_software()
{
	sudo apt update
	case $SW_TYPE in
	"full")
		list=$software_list;;
	"opt")
		list=$optional_list;;
	*)
		list=$minimal_list;;
	esac
	echo "start install software $list..."
	sudo apt install -y $list
	echo "install software finished."
}

remove_software()
{
	case $SW_TYPE in
	"full")
		list=$software_list;;
	"opt")
		list=$optional_list;;
	*)
		list=$minimal_list;;
	esac
	echo "start remove software $list..."
	sudo apt remove $list
	sudo apt autoremove -y
	echo "sremove software finished."
}

install_config()
{
	echo "start install config $config_list..."
	for config_item in $config_list; do
		cp -fr $config_item ~/
	done
	echo "install config finished."
}

remove_config()
{
	echo "start remove config $config_list..."
	for config_item in $config_list; do
		rm -fr ~/$config_item
	done
	echo "remove config finished."
}


install()
{
	add_ppa
	install_software
	install_config
}

remove()
{
	remove_ppa
	remove_config
	remove_software
}

list()
{
	echo "software_list=$software_list==="
	echo "==== software_list ===="
	for item in $software_list; do
		echo "$item"
	done

	echo "==== config_list ===="
	for item in $config_list; do
		echo "$item"
	done

	echo "==== ppa_list ===="
	for item in $ppa_list; do
		echo "$item"
	done

}

usage()
{
	echo "==== Auto Setup Environment Script ===="
	echo "$CMD install|remove|list|help"
	echo "$CMD install: install minimal software"
	echo "$CMD install full: install full software"
	echo "$CMD install opt: install optional software"
	echo "$CMD list: show software list, ppa list and config list"
}

main()
{
	case $ACTION in
	"install")
		install;;
	"remove")
		remove;;
	"list")
		list;;
	"help")
		usage;;
	*)
		usage;
		exit;;
	esac
}

main $@
