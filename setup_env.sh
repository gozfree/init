#!/bin/sh
# Auto Setup Environment Script

CMD=$0
ACTION=$1


software_list="
build-essential
curl
dpkg-dev
dput
exuberant-ctags
ffmpeg
g++ git
htop
meld mplayer
nginx
ppa-purge python-pip python-m2crypto
rar
subversion
vim vlc

"

config_list="
.gitconfig
.vimrc
.vim/
"

ppa_list="
ppa:gozfree/ppa

"


add_ppa()
{
	for ppa_item in $ppa_list; do
		sudo add-apt-repository $ppa_item
	done
}

remove_ppa()
{
	for ppa_item in $ppa_list; do
		sudo ppa-purge $ppa_item
	done
}

install_software()
{
	sudo apt update
	sudo apt install -y $software_list
}

remove_software()
{
	sudo apt remove $software_list
}

install_config()
{
	for config_item in $config_list; do
		cp $config_item -fr ~/
	done
}

remove_config()
{
	for config_item in $config_list; do
		rm $config_item -fr
	done
}


install()
{
	#add_ppa
	install_software
	install_config
}

remove()
{
	remove_software
	remove_config
	remove_ppa
}

list()
{
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
	echo "$0 install|remove|list|help"
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
