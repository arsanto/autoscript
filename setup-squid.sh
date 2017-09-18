#!/bin/bash
# author: Fway  <admin@fway.me>
# Copyright 2012 (c) esteh.info
# 
# Revisi 1:
# Penambahan config agar proxy menjadi super elite
#   header_access Via deny all
#	header_access Forwarded-For deny all
# 	header_access X-Forwarded-For deny all
# 


function baca_port {
    echo -n "Masukkan port untuk squid: "
    read port

	if [[ "$port" =~ ^[0-9]+$ ]] ; then
		echo "http_port $port transparent" >> /tmp/squid.conf.tmp1
		baca_port_lagi
	else
		echo -e "\e[1;31mInput salah!\e[0m"
		baca_port
	fi
}



function baca_port_lagi {
	echo -n "Masukkan port lain untuk squid atau Ketik \"n\" untuk melanjutkan: "
	read port

	if [[ "$port" =~ ^[0-9]+$ ]] ; then
		echo "http_port $port transparent" >> /tmp/squid.conf.tmp1
		baca_port_lagi
	else
		if [ "$port" = "n" ]; then
			echo -e "\e[1;33mInstalasi squid!\e[0m"
		else
			echo -e "\e[1;31mInput salah!\e[0m"
			baca_port_lagi
		fi
	fi
}

function preinstall_squid {
	DEBIAN_FRONTEND=noninteractive apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -q -y remove --purge squid squid*
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
    DEBIAN_FRONTEND=noninteractive apt-get -q -y install sudo
	DEBIAN_FRONTEND=noninteractive sudo apt-get -q -y install squid
	mv /etc/squid3/squid.conf /etc/squid3/squid.conf.bak
	cat > /tmp/squid.conf.tmp2 <<END
cache allow all
http_access allow all
forwarded_for off
via off
httpd_suppress_version_string    on
forwarded_for delete
END
	
	cat /tmp/squid.conf.tmp2 /tmp/squid.conf.tmp1	> /etc/squid3/squid.conf
	cat /dev/null > /etc/security/limits.conf

cat << EOF | tee -a /etc/security/limits.conf
*       -       maxlogins       1
EOF

	service squid3 restart 
	service ssh restart
}


echo "******************************************************************"
echo "*                                                                *"
echo "*                   http://esteh.info                            *"
echo "*        Mencerdaskan dan mencerahkan anak bangsa                *"
echo "*                                                                *"
echo "******************************************************************"

echo ""
echo ""

baca_port
preinstall_squid

