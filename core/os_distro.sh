#!/usr/bin/env bash

#
#   Author:  		based on the original by zeldarealm@gmail.com
#   Source:  		https://github.com/KittyKatt/screenFetch
#	Instructions:	source function-library/os_distro.sh ; detectdistro
#	Version:		1.4.2

verboseOut () {
	if [[ "$verbosity" -eq "1" ]]; then
		printf "\033[1;31m:: \033[0m$1\n"
	fi
}

errorOut () {
	printf "\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m$1\n"
}

stderrOut () {
	while IFS='' read -r line; do printf "\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m${line}\n"; done
}


function amazonlinux_release_version(){
	#
	#  determines release version internally from  within an
	#  amazonlinux host os environment.
	#
	#  Requires identification of AmazonLinux OS Family as a
	#  prerequisite
	#
	local image_id
	local region
	local cwd=$PWD
	local tmp='/tmp'
	#
	cd $tmp
	curl -O 'http://169.254.169.254/latest/dynamic/instance-identity/document'
	image_id="$(jq -r .imageId $tmp/document)"
	region="$(jq -r .region $tmp/document)"
	aws ec2 describe-images --image-ids $image_id --region $region > $tmp/images.json
	printf -- "%s\n" "$(jq -r .Images[0].Name $tmp/images.json | awk -F '-' '{print $1}')"
	rm $tmp/document $tmp/images.json
	cd $cwd
}


function redhat_release_version(){
	#
	#  determines Redhat release version internally from
	#  within a Redhat host os environment.
	#
	#  Requires identification of Redhat Linux OS Family
	#  as a prerequisite
	#
	local release
	#
	release="$(grep VERSION_ID /etc/os-release | awk -F '=' '{print $2}')"
	printf -- "%s\n" $(echo $release | cut -c 2-50 | rev | cut -c 2-50 | rev)
}


function redhat_codename_version(){
	#
	#  determines Redhat codename internally from
	#  within a Redhat host os environment.
	#
	#  Requires identification of Redhat Linux OS Family
	#  as a prerequisite
	#
	local codename
	codename="$(grep VERSION /etc/os-release | head -n 1 | awk -F '(' '{print $2}' | awk -F ')' '{print $1}')"
	printf -- "%s\n" $codename
}


detectdistro () {
	## 															#
	# 	determines:												#
	#		- os family											#
	#		- release (revision) number							#
	#		- codename (informaal name)							#
	##
	local format="$1"       #  accepts "json" or '' (None)
	#
	if [[ -z "${distro}" ]]; then
		distro="Unknown"
		# LSB Release Check
		if type -p lsb_release >/dev/null 2>&1; then
			# read distro_detect distro_release distro_codename <<< $(lsb_release -sirc)
			distro_detect=( $(lsb_release -sirc) )
			if [[ ${#distro_detect[@]} -eq 3 ]]; then
				distro_codename=${distro_detect[2]}
				distro_release=${distro_detect[1]}
				distro_detect=${distro_detect[0]}
			else
				for ((i=0; i<${#distro_detect[@]}; i++)); do
					if [[ ${distro_detect[$i]} =~ ^[[:digit:]]+((.[[:digit:]]+|[[:digit:]]+|)+)$ ]]; then
						distro_release=${distro_detect[$i]}
						distro_codename=${distro_detect[@]:$(($i+1)):${#distro_detect[@]}+1}
						distro_detect=${distro_detect[@]:0:${i}}
						break 1
					elif [[ ${distro_detect[$i]} =~ [Nn]/[Aa] || ${distro_detect[$i]} == "rolling" ]]; then
						distro_release=${distro_detect[$i]}
						distro_codename=${distro_detect[@]:$(($i+1)):${#distro_detect[@]}+1}
						distro_detect=${distro_detect[@]:0:${i}}
						break 1
					fi
				done
			fi
			case "${distro_detect}" in
				"CentOS"|"Chapeau"|"Deepin"|"Devuan"|"DesaOS"|"Fedora"|"gNewSense"|"Jiyuu Linux"|"Kogaion"|"Korora"|"Mageia"|"Netrunner"|"NixOS"|"Pardus"|"Raspbian"|"Sabayon"|"Solus"|"SteamOS"|"Trisquel"|"Ubuntu"|"GrombyangOS"|"Scientific Linux")
					# no need to fix $distro/$distro_codename/$distro_release
					distro="${distro_detect}"
					;;
				"archlinux"|"Arch Linux"|"arch"|"Arch"|"archarm")
					distro="Arch Linux"
					distro_release="n/a"
					if [ -f /etc/os-release ]; then
						os_release="/etc/os-release";
					elif [ -f /usr/lib/os-release ]; then
						os_release="/usr/lib/os-release";
					fi
					if [[ -n ${os_release} ]]; then
						if grep -q 'antergos' /etc/os-release; then
							distro="Antergos"
							distro_release="n/a"
						fi
						if grep -q -i 'logos' /etc/os-release; then
							distro="Logos"
							distro_release="n/a"
						fi
						if grep -q -i 'swagarch' /etc/os-release; then
							distro="SwagArch"
							distro_release="n/a"
						fi
						if grep -q -i 'obrevenge' /etc/os-release; then
							distro="OBRevenge"
							distro_release="n/a"
						fi
					fi
					;;
				"ALDOS"|"Aldos")
					distro="ALDOS"
					;;
				"artixlinux"|"Artix Linux"|"artix"|"Artix"|"Artix release")
					distro="Artix"
					;;
				"blackPantherOS"|"blackPanther"|"blackpanther"|"blackpantheros")
					distro=$(source /etc/lsb-release; echo "$DISTRIB_ID")
					distro_release=$(source /etc/lsb-release; echo "$DISTRIB_RELEASE")
					distro_codename=$(source /etc/lsb-release; echo "$DISTRIB_CODENAME")
					;;
				"BLAG")
					distro="BLAG"
					distro_more="$(head -n1 /etc/fedora-release)"
					;;
				"Chakra")
					distro="Chakra"
					distro_release=""
					;;
				"BunsenLabs")
					distro=$(source /etc/lsb-release; echo "$DISTRIB_ID")
					distro_release=$(source /etc/lsb-release; echo "$DISTRIB_RELEASE")
					distro_codename=$(source /etc/lsb-release; echo "$DISTRIB_CODENAME")
					;;
				"Debian")
					if [[ -f /etc/crunchbang-lsb-release || -f /etc/lsb-release-crunchbang ]]; then
						distro="CrunchBang"
						distro_release=$(awk -F'=' '/^DISTRIB_RELEASE=/ {print $2}' /etc/lsb-release-crunchbang)
						distro_codename=$(awk -F'=' '/^DISTRIB_DESCRIPTION=/ {print $2}' /etc/lsb-release-crunchbang)
					elif [[ -f /etc/siduction-version ]]; then
						distro="Siduction"
						distro_release="(Debian Sid)"
						distro_codename=""
					elif [[ -f /usr/bin/pveversion ]]; then
						distro="Proxmox VE"
						distro_more="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
					elif [[ -f /etc/os-release ]]; then
						if [[ "$(cat /etc/os-release)" =~ "Raspbian" ]]; then
							distro="Raspbian"
							distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
					fi
						if [[ "$(cat /etc/os-release)" =~ "BlankOn" ]]; then
							distro="BlankOn"
							distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
						else
							distro="Debian"
						fi
					else
						distro="Debian"
					fi
					;;
				"elementary"|"elementary OS")
					distro="elementary OS"
					;;
				"EvolveOS")
					distro="Evolve OS"
					;;
				"KaOS"|"kaos")
					distro="KaOS"
					;;
				"frugalware")
					distro="Frugalware"
					distro_codename=null
					distro_release=null
					;;
				"Fuduntu")
					distro="Fuduntu"
					distro_codename=null
					;;
				"Fux")
					distro="Fux"
					distro_codename=null
					;;
				"Gentoo")
					if [[ "$(lsb_release -sd)" =~ "Funtoo" ]]; then
						distro="Funtoo"
					else
						distro="Gentoo"
					fi
					. /etc/portage/make.conf #detecting release stable/testing/experimental
					case $ACCEPT_KEYWORDS in
						[a-z]*) distro_release=stable       ;;
						~*)     distro_release=testing      ;;
						'**')   distro_release=experimental ;; #experimental usually includes git-versions.
					esac
					;;
				"Hyperbola GNU/Linux-libre"|"Hyperbola")
					distro="Hyperbola GNU/Linux-libre"
					distro_codename="n/a"
					distro_release="n/a"
					;;
				"LinuxDeepin")
					distro="LinuxDeepin"
					distro_codename=null
					;;
				"Kali"|"Debian Kali Linux")
					distro="Kali Linux"
					if [[ "${distro_codename}" =~ "kali-rolling" ]]; then
						distro_codename="n/a"
						distro_release="n/a"
					fi
					;;
				"Lunar Linux"|"lunar")
					distro="Lunar Linux"
					;;
				"MandrivaLinux")
					distro="Mandriva"
					case "${distro_codename}" in
						"turtle"|"Henry_Farman"|"Farman"|"Adelie"|"pauillac")
							distro="Mandriva-${distro_release}"
							distro_codename=null
							;;
					esac
					;;
				"ManjaroLinux")
					distro="Manjaro"
					;;
				"Mer")
					distro="Mer"
					if [[ -f /etc/os-release ]]; then
						if grep -q 'SailfishOS' /etc/os-release; then
							distro="SailfishOS"
							distro_codename="$(grep 'VERSION=' /etc/os-release | cut -d '(' -f2 | cut -d ')' -f1)"
							distro_release="$(awk -F'=' '/^VERSION=/ {print $2}' /etc/os-release)"
						fi
					fi
					;;
				"neon"|"KDE neon")
					distro="KDE neon"
					distro_codename="n/a"
					distro_release="n/a"
					if [[ -f /etc/issue ]]; then
						if grep -q "^KDE neon" /etc/issue ; then
							distro_release="$(grep '^KDE neon' /etc/issue | cut -d ' ' -f3)"
						fi
					fi
					;;
				"Ol"|"ol"|"Oracle Linux")
					distro="Oracle Linux"
					[ -f /etc/oracle-release ] && distro_release="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					;;
				"LinuxMint")
					distro="Mint"
					if [[ "${distro_codename}" == "debian" ]]; then
						distro="LMDE"
						distro_codename="n/a"
						distro_release="n/a"
					fi
					;;
				"openSUSE"|"openSUSE project"|"SUSE LINUX")
					distro="openSUSE"
					if [ -f /etc/os-release ]; then
						if [[ "$(cat /etc/os-release)" =~ "SUSE Linux Enterprise" ]]; then
							distro="SUSE Linux Enterprise"
							distro_codename="n/a"
							distro_release=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
						fi
					fi
					if [[ "${distro_codename}" == "Tumbleweed" ]]; then
						distro_release="n/a"
					fi
					;;
				"Parabola GNU/Linux-libre"|"Parabola")
					distro="Parabola GNU/Linux-libre"
					distro_codename="n/a"
					distro_release="n/a"
					;;
				"Parrot"|"Parrot Security")
					distro="Parrot Security"
					;;
				"PCLinuxOS")
					distro="PCLinuxOS"
					distro_codename="n/a"
					distro_release="n/a"
					;;
				"Peppermint")
					distro="Peppermint"
					distro_codename=null
					;;
				"rhel")
					distro="Redhat"
					distro_release="$(redhat_release_version)"
					distro_codename="$(redhat_codename_version)"
					;;
				"RosaDesktopFresh")
					distro="ROSA"
					distro_release=$(grep 'VERSION=' /etc/os-release | cut -d ' ' -f3 | cut -d "\"" -f1)
					distro_codename=$(grep 'PRETTY_NAME=' /etc/os-release | cut -d ' ' -f4,4)
					;;
				"SailfishOS")
					distro="SailfishOS"
					if [[ -f /etc/os-release ]]; then
						distro_codename="$(grep 'VERSION=' /etc/os-release | cut -d '(' -f2 | cut -d ')' -f1)"
						distro_release="$(awk -F'=' '/^VERSION=/ {print $2}' /etc/os-release)"
					fi
					;;
				"Sparky"|"SparkyLinux")
					distro="SparkyLinux"
					;;
				"Viperr")
					distro="Viperr"
					distro_codename=null
					;;
				"Void"|"VoidLinux")
					distro="Void Linux"
					distro_codename=""
					distro_release=""
					;;
				"Zorin")
					distro="Zorin OS"
					distro_codename=""
					;;
				*)
					if [ "x$(printf "${distro_detect}" | od -t x1 | sed -e 's/^\w*\ *//' | tr '\n' ' ' | grep 'eb b6 89 ec 9d 80 eb b3 84 ')" != "x" ]; then
						distro="Red Star OS"
						distro_codename="n/a"
						distro_release=$(printf "${distro_release}" | grep -o '[0-9.]' | tr -d '\n')
					fi
					;;
			esac
			if [[ "${distro_detect}" =~ "RedHatEnterprise" ]]; then
				distro="Redhat"
				distro_release="$(redhat_release_version)"
				distro_codename="$(redhat_codename_version)"
			fi
			if [[ "${distro_detect}" =~ "SUSELinuxEnterprise" ]]; then distro="SUSE Linux Enterprise"; fi
			if [[ -n ${distro_release} && ${distro_release} != "n/a" ]]; then distro_more="$distro_release"; fi
			if [[ -n ${distro_codename} && ${distro_codename} != "n/a" ]]; then distro_more="$distro_more $distro_codename"; fi
		fi

		# Existing File Check
		if [ "$distro" == "Unknown" ]; then
			if [ $(uname -o 2>/dev/null) ]; then
				os="$(uname -o)"
				case "$os" in
					"Cygwin"|"FreeBSD"|"OpenBSD"|"NetBSD")
						distro="$os"
						fake_distro="${distro}"
					;;
					"DragonFly")
						distro="DragonFlyBSD"
						fake_distro="${distro}"
					;;
					"Msys")
						distro="Msys"
						fake_distro="${distro}"
						distro_more="${distro} $(uname -r | head -c 1)"
					;;
					"Haiku")
						distro="Haiku"
						distro_more="$(uname -v | tr ' ' '\n' | grep 'hrev')"
					;;
					"GNU/Linux")
						if type -p crux >/dev/null 2>&1; then
							distro="CRUX"
							distro_more="$(crux | awk '{print $3}')"
						fi
						if type -p nixos-version >/dev/null 2>&1; then
							distro="NixOS"
							distro_more="$(nixos-version)"
						fi
						if type -p sorcery >/dev/null 2>&1; then
							distro="SMGL"
						fi
						if (type -p guix && type -p herd) >/dev/null 2>&1; then
							distro="GuixSD"
						fi
					;;
				esac
			fi
			if [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
				# https://msdn.microsoft.com/en-us/library/ms724832%28VS.85%29.aspx
				if [ "$(wmic os get version | grep -o '^\(6\.[23]\|10\)')" ]; then
					fake_distro="Windows - Modern"
				fi
			fi
			if [[ "${distro}" == "Unknown" ]]; then
				if [ -f /etc/os-release ]; then
					os_release="/etc/os-release";
				elif [ -f /usr/lib/os-release ]; then
					os_release="/usr/lib/os-release";
				fi
				if [[ -n ${os_release} ]]; then
					distrib_id=$(<${os_release});
					for l in $(echo $distrib_id); do
						if [[ ${l} =~ ^ID= ]]; then
							distrib_id=${l//*=}
							distrib_id=${distrib_id//\"/}
							break 1
						fi
					done
					if [[ -n ${distrib_id} ]]; then
						if [[ -n ${BASH_VERSINFO} && ${BASH_VERSINFO} -ge 4 ]]; then
							distrib_id=$(for i in ${distrib_id}; do echo -n "${i^} "; done)
							distro=${distrib_id% }
							unset distrib_id
						else
							distrib_id=$(for i in ${distrib_id}; do FIRST_LETTER=$(echo -n "${i:0:1}" | tr "[:lower:]" "[:upper:]"); echo -n "${FIRST_LETTER}${i:1} "; done)
							distro=${distrib_id% }
							unset distrib_id
						fi
					fi

					# Hotfixes
					[[ "${distro}" == "void" ]] && distro="Void Linux"
					[[ "${distro}" == "evolveos" ]] && distro="Evolve OS"
					[[ "${distro}" == "antergos" ]] && distro="Antergos"
					[[ "${distro}" == "logos" ]] && distro="Logos"
					[[ "${distro}" == "Arch" || "${distro}" == "Archarm" || "${distro}" == "archarm" ]] && distro="Arch Linux"
					[[ "${distro}" == "elementary" ]] && distro="elementary OS"
					[[ "${distro}" == "Fedora" && -d /etc/qubes-rpc ]] && distro="qubes" # Inner VM
					[[ "${distro}" == "Ol" || "${distro}" == "ol" ]] && distro="Oracle Linux"
					if [[ "${distro}" == "Oracle Linux" ]] && [ -f /etc/oracle-release ]; then
						distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					fi
					[[ "${distro}" == "rhel" ]] && distro="Redhat"
					[[ "${distro}" == "Neon" ]] && distro="KDE neon"
					[[ "${distro}" == "SLED" || "${distro}" == "sled" || "${distro}" == "SLES" || "${distro}" == "sles" ]] && distro="SUSE Linux Enterprise"
					if [[ "${distro}" == "SUSE Linux Enterprise" ]] && [ -f /etc/os-release ]; then
						distro_more="$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')"
					fi
					if [[ "${distro}" == "Debian" ]] && [ -f /usr/bin/pveversion ]; then
						distro="Proxmox VE"
						distro_more="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
					fi
				fi
			fi

			if [[ "${distro}" == "Unknown" ]]; then
				if [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" ]]; then
					if [ -f /etc/lsb-release ]; then
						LSB_RELEASE=$(</etc/lsb-release)
						distro=$(echo ${LSB_RELEASE} | awk 'BEGIN {
							distro = "Unknown"
						}
						{
							if ($0 ~ /[Uu][Bb][Uu][Nn][Tt][Uu]/) {
								distro = "Ubuntu"
								exit
							}
							else if ($0 ~ /[Mm][Ii][Nn][Tt]/ && $0 ~ /[Dd][Ee][Bb][Ii][Aa][Nn]/) {
								distro = "LMDE"
								exit
							}
							else if ($0 ~ /[Mm][Ii][Nn][Tt]/) {
								distro = "Mint"
								exit
							}
						} END {
							print distro
						}')
					fi
				fi
			fi

			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" || "${OSTYPE}" == "gnu" ]]; then
					for di in arch chakra crunchbang-lsb evolveos exherbo fedora \
								frugalware fux gentoo kogaion mageia obarun oracle \
								pardus pclinuxos redhat redstar rosa SuSe; do
						if [ -f /etc/$di-release ]; then distro=$di && break; fi
					done
					if [[ "${distro}" == "crunchbang-lsb" ]]; then
						distro == "Crunchbang"
					elif [[ "${distro}" == "gentoo" ]]; then
						grep -q "Funtoo" /etc/gentoo-release && distro="Funtoo"
					elif [[ "${distro}" == "mandrake" ]] || [[ "${distro}" == "mandriva" ]]; then
						grep -q "PCLinuxOS" /etc/${distro}-release && distro="PCLinuxOS"
					elif [[ "${distro}" == "fedora" ]]; then
						grep -q "Korora" /etc/fedora-release && distro="Korora"
						grep -q "BLAG" /etc/fedora-release && distro="BLAG" && distro_more="$(head -n1 /etc/fedora-release)"
					elif [[ "${distro}" == "oracle" ]]; then
						distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					elif [[ "${distro}" == "SuSe" ]]; then
						distro="openSUSE"
						if [ -f /etc/os-release ]; then
							if [[ "$(cat /etc/os-release)" =~ "SUSE Linux Enterprise" ]]; then
								distro="SUSE Linux Enterprise"
								distro_more=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
							fi
						fi
						if [[ "${distro_more}" =~ "Tumbleweed" ]]; then
							distro_more="Tumbleweed"
						fi
					elif [[ "${distro}" == "redstar" ]]; then
						distro_more=$(grep -o '[0-9.]' /etc/redstar-release | tr -d '\n')
					elif [[ "${distro}" == "redhat" ]]; then
						grep -q "CentOS" /etc/redhat-release && distro="CentOS"
						grep -q "PCLinuxOS" /etc/redhat-release && distro="PCLinuxOS"
						if [ "x$(od -t x1 /etc/redhat-release | sed -e 's/^\w*\ *//' | tr '\n' ' ' | grep 'eb b6 89 ec 9d 80 eb b3 84 ')" != "x" ]; then
							distro="Red Star OS"
							distro_more=$(grep -o '[0-9.]' /etc/redhat-release | tr -d '\n')
						fi
						distro_release="$(redhat_release_version)"
						distro_codename="$(redhat_codename_version)"
					fi
			fi

			if [[ "${distro}" == "Unknown" ]]; then
				if [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [ -f /etc/debian_version ]; then
						if [ -f /etc/issue ]; then
							if grep -q "gNewSense" /etc/issue ; then
								distro="gNewSense"
							elif grep -q "^KDE neon" /etc/issue ; then
								distro="KDE neon"
								distro_more="$(cut -d ' ' -f3 /etc/issue)"
							else
								distro="Debian"
							fi
						fi
						if grep -q "Kali" /etc/debian_version ; then
							distro="Kali Linux"
						fi
					elif [ -f /etc/NIXOS ]; then distro="NixOS"
					elif [ -f /etc/dragora-version ]; then
						distro="Dragora"
						distro_more="$(cut -d, -f1 /etc/dragora-version)"
					elif [ -f /etc/slackware-version ]; then distro="Slackware"
					elif [ -f /usr/share/doc/tc/release.txt ]; then
						distro="TinyCore"
						distro_more="$(cat /usr/share/doc/tc/release.txt)"
					elif [ -f /etc/sabayon-edition ]; then distro="Sabayon"
					fi
				else
					if [[ -x /usr/bin/sw_vers ]] && /usr/bin/sw_vers | grep -i "Mac OS X" >/dev/null; then
						distro="Mac OS X"
					elif [[ -f /var/run/dmesg.boot ]]; then
						distro=$(awk 'BEGIN {
							distro = "Unknown"
						}
						{
							if ($0 ~ /DragonFly/) {
								distro = "DragonFlyBSD"
								exit
							}
							else if ($0 ~ /FreeBSD/) {
								distro = "FreeBSD"
								exit
							}
							else if ($0 ~ /NetBSD/) {
								distro = "NetBSD"
								exit
							}
							else if ($0 ~ /OpenBSD/) {
								distro = "OpenBSD"
								exit
							}
						} END {
							print distro
						}' /var/run/dmesg.boot)
					fi
				fi
			fi

			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" || "${OSTYPE}" == "gnu" ]]; then
				if [[ -f /etc/issue ]]; then
					distro=$(awk 'BEGIN {
						distro = "Unknown"
					}
					{
						if ($0 ~ /"Hyperbola GNU\/Linux-libre"/) {
							distro = "Hyperbola GNU/Linux-libre"
							exit
						}
						else if ($0 ~ /"LinuxDeepin"/) {
							distro = "LinuxDeepin"
							exit
						}
						else if ($0 ~ /"Obarun"/) {
							distro = "Obarun"
							exit
						}
						else if ($0 ~ /"Parabola GNU\/Linux-libre"/) {
							distro = "Parabola GNU/Linux-libre"
							exit
						}
						else if ($0 ~ /"Solus"/) {
							distro = "Solus"
							exit
						}
						else if ($0 ~ /"ALDOS"/) {
							distro = "ALDOS"
							exit
						}
					} END {
						print distro
					}' /etc/issue)
				fi
			fi

			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" || "${OSTYPE}" == "gnu" ]]; then
				if [[ -f /etc/system-release ]]; then
					if grep -q "Scientific Linux" /etc/system-release; then
						distro="Scientific Linux"
					elif grep -q "Oracle Linux" /etc/system-release; then
						distro="Oracle Linux"
					fi
				elif [[ -f /etc/lsb-release ]]; then
					if grep -q "CHROMEOS_RELEASE_NAME" /etc/lsb-release; then
						distro="$(awk -F'=' '/^CHROMEOS_RELEASE_NAME=/ {print $2}' /etc/lsb-release)"
						distro_more="$(awk -F'=' '/^CHROMEOS_RELEASE_VERSION=/ {print $2}' /etc/lsb-release)"
					fi
				fi
			fi
		fi
	fi

	if [[ -n ${distro_more} ]]; then
		distro_more="${distro} ${distro_more}"
	fi

	if [[ "${distro}" != "Haiku" ]]; then
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
				distro=${distro,,}
			else
				distro="$(tr '[:upper:]' '[:lower:]' <<< ${distro})"
			fi
		else
			distro="$(tr '[:upper:]' '[:lower:]' <<< ${distro})"
		fi
	fi

	case $distro in
		aldos) distro="ALDOS";;
		alpine) distro="Alpine Linux" ;;
		amzn|amazon|amazon*linux)
			distro="AmazonLinux"
			if [ "$(grep VERSION_ID /etc/os-release | awk -F '=' '{print $2}')" = '"2"' ]; then
				distro_release="2"
			elif [ "${amazonlinux_release_version}" != "2" ]; then
				distro_release="1"
			else
				distro_release="unknown"
			fi
			;;
		antergos) distro="Antergos" ;;
		arch*linux*old) distro="Arch Linux - Old" ;;
		arch|arch*linux) distro="Arch Linux" ;;
		artix|artix*linux) distro="Artix Linux" ;;
		blackpantheros|black*panther*) distro="blackPanther OS" ;;
		blag) distro="BLAG" ;;
		bunsenlabs) distro="BunsenLabs" ;;
		centos)
			distro="CentOS"
			distro_release="$(redhat_release_version)"
			distro_codename="$(redhat_codename_version)"
			;;
		chakra) distro="Chakra" ;;
		chapeau) distro="Chapeau" ;;
		chrome*|chromium*) distro="Chrome OS" ;;
		crunchbang) distro="CrunchBang" ;;
		crux) distro="CRUX" ;;
		cygwin) distro="Cygwin" ;;
		debian) distro="Debian" ;;
		devuan) distro="Devuan" ;;
		deepin) distro="Deepin" ;;
		desaos) distro="DesaOS" ;;
		dragonflybsd) distro="DragonFlyBSD" ;;
		dragora) distro="Dragora" ;;
		elementary|'elementary os') distro="elementary OS";;
		evolveos) distro="Evolve OS" ;;
		exherbo|exherbo*linux) distro="Exherbo" ;;
		fedora) distro="Fedora" ;;
		freebsd) distro="FreeBSD" ;;
		freebsd*old) distro="FreeBSD - Old" ;;
		frugalware) distro="Frugalware" ;;
		fuduntu) distro="Fuduntu" ;;
		funtoo) distro="Funtoo" ;;
		fux) distro="Fux" ;;
		gentoo) distro="Gentoo" ;;
		gnewsense) distro="gNewSense" ;;
		guixsd) distro="GuixSD" ;;
		haiku) distro="Haiku" ;;
		hyperbolagnu|hyperbolagnu/linux-libre|'hyperbola gnu/linux-libre'|hyperbola) distro="Hyperbola GNU/Linux-libre" ;;
		kali*linux) distro="Kali Linux" ;;
		kaos) distro="KaOS";;
		kde*neon|neon) distro="KDE neon" ;;
		kogaion) distro="Kogaion" ;;
		korora) distro="Korora" ;;
		linuxdeepin) distro="LinuxDeepin" ;;
		lmde) distro="LMDE" ;;
		logos) distro="Logos" ;;
		lunar|lunar*linux) distro="Lunar Linux";;
		mac*os*x|os*x) distro="Mac OS X" ;;
		manjaro) distro="Manjaro" ;;
		mageia) distro="Mageia" ;;
		mandrake) distro="Mandrake" ;;
		mandriva) distro="Mandriva" ;;
		mer) distro="Mer" ;;
		mint|linux*mint) distro="Mint" ;;
		msys|msys2) distro="Msys" ;;
		netbsd) distro="NetBSD" ;;
		netrunner) distro="Netrunner" ;;
		nix|nix*os) distro="NixOS" ;;
		obarun) distro="Obarun" ;;
		obrevenge) distro="OBRevenge" ;;
		ol|oracle*linux) distro="Oracle Linux" ;;
		openbsd) distro="OpenBSD" ;;
		opensuse) distro="openSUSE" ;;
		parabolagnu|parabolagnu/linux-libre|'parabola gnu/linux-libre'|parabola) distro="Parabola GNU/Linux-libre" ;;
		pardus) distro="Pardus" ;;
		parrot|parrot*security) distro="Parrot Security" ;;
		pclinuxos|pclos) distro="PCLinuxOS" ;;
		peppermint) distro="Peppermint" ;;
		proxmox|proxmox*ve) distro="Proxmox VE" ;;
		qubes) distro="Qubes OS" ;;
		raspbian) distro="Raspbian" ;;
		red*hat*|rhel)
			distro="Redhat"
			distro_release="$(redhat_release_version)"
			distro_codename="$(redhat_codename_version)"
			;;
		rosa) distro="ROSA" ;;
		red*star|red*star*os) distro="Red Star OS" ;;
		sabayon) distro="Sabayon" ;;
		sailfish|sailfish*os) distro="SailfishOS" ;;
		siduction) distro="Siduction" ;;
		slackware) distro="Slackware" ;;
		smgl|source*mage|source*mage*gnu*linux) distro="Source Mage GNU/Linux" ;;
		solus) distro="Solus" ;;
		sparky|sparky*linux) distro="SparkyLinux" ;;
		steam|steam*os) distro="SteamOS" ;;
		suse*linux*enterprise) distro="SUSE Linux Enterprise" ;;
		swagarch) distro="SwagArch" ;;
		tinycore|tinycore*linux) distro="TinyCore" ;;
		trisquel) distro="Trisquel";;
		grombyangos) distro="GrombyangOS" ;;
		ubuntu)
			distro="Ubuntu"
			if grep -q 'Microsoft' /proc/version 2>/dev/null || \
			   grep -q 'Microsoft' /proc/sys/kernel/osrelease 2>/dev/null
			then
				uow=$(echo -e "$(getColor 'yellow') [Ubuntu on Windows 10]")
			fi
			;;
		viperr) distro="Viperr" ;;
		void*linux) distro="Void Linux" ;;
		zorin*) distro="Zorin OS" ;;
	esac
	if [ "$format" = "json" ]; then
		echo "{\"Major\": \"${distro}\", \"Release\": \"${distro_release}\", \"Codename\": \"${distro_codename}\"}"
	else
		echo "${distro} ${distro_release} ${distro_codename}"
	fi
}

# call main
detectdistro
