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
#	1.6 - 17.04.2024 - Download automático dos arquivos na instalação	#
#										#
#################################################################################

VS='Versão-1.6'

# CORES ==========================
R="[38;5;160m"  # Red
G="[38;5;76m"   # Green
C="[38;5;81m"   # Cian

F="[1m"  # Claro
O="[2m"  # Escuro
N="[6m"  # Normal
Z="[0m"  # Zerar
#=================================

l="--------------------------------------------------------------------------------------------------------"
prog=$(echo $0 | sed 's/.*\///g')
dir="/usr/share/firefox"
arq1=$(pwd $2)
arq="$HOME/Downloads/firefox*"
desk="$HOME/Desktop/firefox.desktop"

if [ ! -f "$arq1" ];then
	v=$(ls $HOME/Downloads/firefox* | sed 's/.*-//g;s/.tar.*//g')
else
	v=$(ls $arq1 | sed 's/.*-//g;s/.tar.*//g')
fi

# https://www.mozilla.org/pt-BR/firefox/download/thanks/	( Links diretos arqv br.fire.bz2 ) 
# https://download-installer.cdn.mozilla.net/pub/firefox/releases/125.0.1/linux-x86_64/pt-BR/firefox-125.0.1.tar.bz2

msg="
$C$N$l
  InstallFire é um programa instalador do arquivo .zip do Firefox
  faça o download do arquivo em https://www.mozilla.org/pt-BR/firefox/all/#product-desktop-release 
	
  Uso:
  $G$F      $prog [$C-c, -i, -h, -r, -v$G] firefox.zip $Z

  $C$N	-c -- Configurar o$G$F $prog $Z$C$N no sistema, depois de configurado usar [ instfire ]
  	-i -- Instalar o Firefox, caso não tenha feito o download do zip ele será feito automáticamente
	-h -- Help, informações de uso
	-r -- Remover o Firefox do sistema
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
		sudo cp $local/installfire.sh /usr/share/installfire/installfire
		sudo chown root:root /usr/share/installfire/*
		sudo chmod 755 /usr/share/installfire/*
		sudo ln -s /usr/share/installfire/installfire /usr/bin/instfire
		sudo chown root:root /usr/bin/instfire
		sudo chmod 755 /usr/bin/instfire
		sleep 1
  	else
		echo -e "$F$G\n\t\tDiretório encontrado, configurndo Programa..\n$Z"

		sudo rm -f /usr/share/installfire/*
		sudo cp $local/installfire.sh /usr/share/installfire/installfire
		sudo chown root:root /usr/share/installfire/*
		sudo chmod 755 /usr/share/installfire/*
		sudo ln -s -f /usr/share/installfire/installfire /usr/bin/instfire
		sudo chown root:root /usr/bin/instfire
		sudo chmod 755 /usr/bin/instfire
		sleep 1
	fi
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

	if [ "$USER" != "root" ]; then
		sudo rm -rf /usr/share/firefox/*
		sudo rm -f /usr/share/applications/firefox*
		sudo rm -f $HOME/Desktop/firefox.*
	else
		rm -rf /usr/share/firefox/*
		rm -f /usr/share/applications/firefox*
		rm -f $HOME/Desktop/firefox.*
	fi

	clear
	echo $G$F$l
	echo -e "\n\t\tFirefox removido\n "
	echo $l$Z
	sleep 1
	clear
}

# Download e instalação direta do Firefox PT-BR (Configurar o link para sua lingua )================
download(){
	clear
	if [ ! -f $arq ]; 
	then
		clear
		echo -e "$F$R\n\t\tArquivo não encontrado em Downloads!\n\n"
		sleep .5
		
		echo -e "$G$F==[ Baixando o$C$F Firefox$G$F ]================================"

		#== MUDE AQUI A VERSÃO DO DOWNLOAD [ /releases/**  e  nome do arquivo-**.tar ]==============
		wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/125.0.1/linux-x86_64/pt-BR/firefox-125.0.1.tar.bz2 -P $HOME/Downloads/
		sleep .5
	fi
}

# Extração do arqv .tar ====================
install(){
	clear
	pkill firefox
	sleep 1

	if [ "$USER" != "root" ];
	then
		if [ ! -f $arq ]; 
		then		
			clear
			echo -e "$F$R\n\t\tArquivo não encontrado em Downloads!
		$F${C}Vamos tentar baixá-lo em$F$G https://download-installer.cdn.mozilla.net/pub/firefox/releases/125.0.1/linux-x86_64/
		$F${C}Verifique seu idioma no link de download, este download tem por padrão $F${G}pt-BR.\n\n"
			echo -ne "$F$C Pressione 'Enter' para sair: $Z"; read
			clear
			download 
			install
		else
			echo -e "$G$F\n\t\tDescompactando arquivos.. \n$C$N"
			sudo tar -vxjf $arq -C $dir --overwrite 
		fi
	else
		if [ ! -f $arq ]; 
		then
			clear
			echo -e "$F$R\n\t\tArquivo não encontrado em Downloads!
		$F${C}Vamos tentar baixá-lo em$F$G https://download-installer.cdn.mozilla.net/pub/firefox/releases/125.0.1/linux-x86_64/
		$F${C}Verifique seu idioma no link de download, este download tem por padrão $F${G}pt-BR.\n\n"
			echo -ne "$F$C Pressione 'Enter' para sair: $Z"; read
			clear
			download 
			install
		else
			echo -e "$G$F\n\t\tDescompactando arquivos.. \n$C$N"
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

# Opções do programa ======================
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


#== I.G.W.T ====================
# Tk082

