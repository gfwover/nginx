#!/bin/bash
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
fi

web_deploy(){
	$systemPackage update -y
	$systemPackage -y install nginx unzip curl wget
	systemctl enable nginx
	systemctl stop nginx
if test -s /etc/nginx/nginx.conf; then
	rm -rf /etc/nginx/nginx.conf
  wget -P /etc/nginx https://raw.githubusercontent.com/gfwover/nginx/master/nginx.conf
	green "================================="
	blue "     请输入需要绑定的域名"
	green "================================="
	read your_domain
  sed -i "s/localhost/$your_domain/;" /etc/nginx/nginx.conf
	green " "
	green "================================="
	 blue "    开始下载伪装站点源码并部署"
	green "================================="
	sleep 2s
	rm -rf /usr/share/nginx/html/*
	cd /usr/share/nginx/html/
	green "================================="
	blue "     请输入伪装网站版本号"
	green "================================="
	read version
	wget https://github.com/gfwover/nginx/releases/download/$version/web.zip
	unzip web.zip
	
  systemctl restart nginx
  green " "
  green " "
  green " "
	green "=================================================================="
	 blue "  伪装站点目录 /usr/share/nginx/html "
	 blue "  伪装网站地址 http://$your_domain "
	green "=================================================================="
else
	green "==============================="
	  red "     Nginx未正确安装 请重试"
	green "==============================="
	sleep 2s
	exit 1
fi
}

start_menu(){
  clear
	green "=========================================================="
      red " Nginx快捷建站脚本"
	green "=========================================================="
	  red " 推荐Debian Ubuntu"
	green "=========================================================="
	 blue " 1. 部署 Web 伪装站点"
     blue " 0. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
    1)
		web_deploy
		;;
		0)
		exit 0
		;;
		*)
	clear
	echo "请输入正确数字"
	sleep 2s
	start_menu
	;;
    esac
}

start_menu
