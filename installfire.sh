#!/usr/bin/env bash
#################################################################################
#										#
#	InstallFire - Intalador do arquivo .zip do Firefox			#
#										#
#	Alan Souza - B^r@t4º							#
#	alan.bt@hotmail.com							#
#	10.02.2020								#
#										#
#-------------------------------------------------------------------------------#
#										#
#	1.0 - 23.02.2020 - Esboço da aplicação					#
#	1.1 - 10.02.2020 - Tratamento de parâmetros				#
#	1.3 - 15.04.2020 - Incremento da configuração do programa no sistema	#
#	1.4 - 22.05.2020 - Dando uma avivada no programa, com cores		#
#	1.5 - 17.10.2021 - Correção de Opções para Usuário Root			#
#										#
#################################################################################

VS='Versão-1.5'

# CORES ==========================
R="[38;5;160m"  # Red
G="[38;5;76m"   # Green
C="[38;5;81m"   # Cian

F="[1m"  # Claro
O="[2m"  # Escuro
N="[6m"  # Normal
Z="[0m"  # Zerar
#=================================

l="---------------------------------------------------------------------------------------"
prog=$(echo $0 | sed 's/.*\///g')
usrX=$USER;
dir="/usr/share/firefox"
arq1=$(pwd/$2);

#if [ "$usrX" != "root" ]; 
#then
#	arq="$HOME/Downloads/firefox*"
#	desk="/home/$usrX/Desktop/firefox.desktop"
	
#	if [ ! -f "$arq1" ];
#	then
#		v=$(ls /home/$usrX/Downloads/firefox* | sed 's/.*-//g;s/.tar.*//g')
#	else
##		v=$(ls $arq1 | sed 's/.*-//g;s/.tar.*//g')
#	fi
#else
	arq="$HOME/Downloads/firefox*"
	desk="$HOME/Desktop/firefox.desktop"

	if [ ! -f "$arq1" ];
	then
		v=$(ls $HOME/Downloads/firefox* | sed 's/.*-//g;s/.tar.*//g')
	else
		v=$(ls $arq1 | sed 's/.*-//g;s/.tar.*//g')
	fi
#fi

# https://www.mozilla.org/pt-BR/firefox/download/thanks/	( Link direto arqv br.fire.bz2 ) 
#https://download-installer.cdn.mozilla.net/pub/firefox/releases/125.0.1/linux-x86_64/pt-BR/firefox-*.tar.bz2

msg="
$C$N$l
  InstallFire é um programa instalador do arquivo .zip do Firefox
  faça o download do arquivo em https://www.mozilla.org/pt-BR/firefox/all/#product-desktop-release 
	
  Uso:
  $G$F      installfire [$C-c, -i, -h, -r, -v$G] firefox.zip $Z

  $C$N	-c -- Configurar o$G$F $prog $Z$C$N no Sistema
	-i -- Instalar o Firefox
	-h -- Help, informações de uso
	-r -- Remover o Firefox
	-v -- Versão
$l $Z
"

			# Dados a serem gravados no ícone
ico(){		
echo "[Desktop Entry]" > $desk
echo "Categories=Network;" >> $desk
echo "Comment=Navegador Web" >> $desk
echo "Exec=/usr/share/firefox/firefox/firefox" >> $desk
echo "Icon=/usr/share/firefox/firefox/browser/chrome/icons/default/default64.png" >> $desk
echo "Name=Firefox" >> $desk
echo "StartupNotify=false" >> $desk
echo "Terminal=false" >> $desk
echo "Type=Application" >> $desk
echo "Version=$v" >> $desk
echo "AppID=firefox" >> $desk
}

	# Configuração do InstallFire no Sistema =================
config(){
	local=$(pwd)
	if [ ! -d "/usr/share/installfire" ]; then
		sudo mkdir /usr/share/installfire/
		sudo cp $local/installfire /usr/share/installfire/
		sudo chown root:root /usr/share/installfire/*
		sudo chmod 755 /usr/share/installfire/*
		sudo ln -s /usr/share/installfire/installfire /usr/bin/instfire
		sudo chown root:root /usr/bin/instfire
		sudo chmod 755 /usr/bin/instfire
		sleep 1
  	else
		echo -e "$F$G\n\t\tDiretório encontrado, configurndo Programa..\n$Z"

		sudo cp $local/installfire /usr/share/installfire/
		sudo chown root:root /usr/share/installfire/*
		sudo chmod 755 /usr/share/installfire/*
		sudo ln -s -f /usr/share/installfire/installfire /usr/bin/instfire
		sudo chown root:root /usr/bin/instfire
		sudo chmod 755 /usr/bin/instfire
		sleep 1
	fi
}

	# Download e instalação direta do Firefox PT-BR (Configurar o link para sua lingua )================
download(){
	clear
	pkill firefox
	rm -f $HOME/Downloads/firefox*
	if [ ! -f $arq ]; 
	then
		clear
		echo -e "$F$R\n\t\tArquivo não encontrado em Downloads!\n\n"
		sleep .5
		echo -e "$G$F==[ Baixando o$C$F Firefox$G$F ]================================"
		wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/125.0.1/linux-x86_64/pt-BR/firefox-125.0.1.tar.bz2 -P $HOME/Downloads/
		sleep .5
		clear
		if [ "$usrX" != "root" ];
		then
			sudo tar -vxjf $arq -C $dir --overwrite 
			exit 0
		else
			tar -vxjf $arq -C $dir --overwrite 
			exit 0
		fi
	fi
	sleep 1
	clear

	echo -e "$G$F\t\tCriando atalho..$Z"
	touch $desk
	ico
	chmod +x $desk
	chown $USER:$USER $desk
	sudo cp $desk /usr/share/applications/

}

	# Verificar se o diretório existe, caso contrário, cria ====================
pathfire(){
	if [ ! -d "$dir" ];
	then
		sudo mkdir /usr/share/firefox
	else
		clear
		echo -e "\tDiretório existente para instalação\n"
	fi
}

	# Classe para remover o Firefox ======================
remove(){
	clear
	echo -e "$R$F\t\tRemovendo o firefox..$Z"

	if [ "$usrX" != "root" ]; then
		sudo rm -rf /usr/share/firefox/*
		sudo rm -f /usr/share/applications/firefox*
		sudo rm -f /home/$usrX/Desktop/firefox.*
	else
		rm -rf /usr/share/firefox/*
		rm -f /usr/share/applications/firefox*
		rm -f /$usrX/Desktop/firefox.*
	fi

	clear
	echo $G$F$l
	echo -e "\n\t\tFirefox removido\n "
	echo $l$Z
	sleep 1
	clear
}

	# Extração do arqv .tar ====================
install(){
	clear
	pkill firefox
	sleep 1
	echo -e "$G$F\n\t\tDescompactando arquivos.. \n$C$N"

	if [ "$usrX" != "root" ];
	then
		if [ ! -f $arq ]; 
		then		
			clear
			echo -e "$F$R\n\t\tArquivo não encontrado em Downloads!
		Faça o download do arquivo em$F$G https://www.mozilla.org/pt-BR/firefox/download/thanks/\n\n"
			echo -ne "$F$R Pressione 'Enter' para sair: $Z"; read
			clear
			exit 1
		else
			sudo tar -vxjf $arq -C $dir --overwrite 
		fi
	else
		if [ ! -f $arq ]; 
		then
			clear
			echo -e "$F$R\n\t\tArquivo não encontrado em Downloads!
		Faça o download do arquivo em$F$G https://www.mozilla.org/pt-BR/firefox/download/thanks/\n\n"
			echo -ne "$F$R Pressione 'Enter' para sair: $Z"; read
			clear
			exit 1
		else
			tar -vxjf $arq -C $dir --overwrite 
		fi
	fi

	sleep 1
	clear

	echo -e "$G$F\t\tCriando atalho..$Z"
	touch $desk
	ico
	chmod +x $desk
	chown $USER:$USER $desk
	sudo cp $desk /usr/share/applications/
	sleep 1
}


case $1 in  
   -h)
	clear
	echo "$msg"
	echo -ne "$F$C Pressione 'Enter' para sair: $Z"; read
	clear
	;;
   -c)
	clear
	config &&
	while [ config != True ];
	do
		echo $l
		echo -e "$G$F\t\t$prog Instalado com Sucesso!!$Z"
		sleep 1.5
		clear
		exit 0
	done
	;;
   -d )
	pathfire
	download
	while [ download != True ];
	do
		clear
		echo $G$F$l
		echo -e "\t\tFirefox instalado com sucesso!!"
		echo $l$Z
		sleep 1.5
		clear
		exit 0
	done
	;;
   -i ) 
	pathfire
	install

	while [ install != True ];
	do
		clear
		echo $G$F$l
		echo -e "\t\tFirefox instalado com sucesso!!"
		echo $l$Z
		sleep 1.5
		clear
		exit 0
	done
	;;
   -r) 
	remove
	exit 0
	;;
   -v) 
	clear
	echo -en "\n\t$G$F[4m$prog$Z -"
	echo -e "$C$F $VS\n $Z"
	sleep 1.5
	clear
	exit 0
	;;
esac

# Tk082_

