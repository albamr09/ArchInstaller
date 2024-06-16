#!/bin/bash


instalar_dependencias(){
	
  echo "---------------------------------------------------"
  echo "-------------- Instalar dependencias --------------"
  echo "---------------------------------------------------"
  
  yay -S i3-wm i3-gaps polybar-git picom-ftlabs-git alacritty neovim nitrogen rofi ttf-font-awesome awesome-terminal-fonts pamixer ranger scrot zsh nodejs npm qutebrowser playerctl python3 python-pip xss-lock zathura i3lock-color yarn acpi dunst llvm clang cmake ripgrep lldb tmux bluetooth-autoconnect
  pip3 install dbus-python tmux pipewire pipewire-pulse pipewire-jack pipewire-alsa pipewire-audio bluez bluez-utils
  
  echo "----------------------------------------------"
  echo " + Intalar oh-my-zsh"
  echo "----------------------------------------------"
  
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  # Hacer predeterminado
  chsh -s /bin/zsh
}

eliminar_wallpapers(){

  echo "---------------------------------------------------"
  echo "--------------- Eliminar wallpapers ---------------"
  echo "---------------------------------------------------"
  
  rm -rf $HOME/.config/wallpapers
}

copiar_dotfiles(){
	
  echo "---------------------------------------------------"
  echo "----------------- Copiar dotfiles -----------------"
  echo "---------------------------------------------------"
  
  cp -r home/.??* /home/$USER
  # Lightdm dotfiles
	sudo cp -r etc/* /etc
}

copiar_fuentes(){
	
  echo "---------------------------------------------------"
  echo "----------------- Copiar fuentes -----------------"
  echo "---------------------------------------------------"
  
  sudo cp -r fonts/* /usr/share/fonts
}

copiar_servicios(){

  echo "---------------------------------------------------"
  echo "-------- Copiar y configurar servicios ------------"
  echo "---------------------------------------------------"
  
  sudo cp services/* /etc/systemd/system
  # Servicio de suspension
  sudo systemctl enable suspend@alba
  # Servicio de notificación de batería
  systemctl --user enable check-battery-user.timer
  # Servicio de notificación de batería
  systemctl --user start check-battery-user.service
  #Actualizar
  sudo systemctl daemon-reload
}

instalar_caffeine(){

  echo "---------------------------------------------------"
  echo "--------------- Instalar caffeine -----------------"
  echo "---------------------------------------------------"
  
  # Instalar
  yay -S libappindicator-gtk3 pulseaduio caffeine-ng
}

configurar_typewritten(){

  echo "---------------------------------------------------"
  echo "------------ Configurar typewritten ---------------"
  echo "---------------------------------------------------"

  git clone https://github.com/reobin/typewritten.git $ZSH_CUSTOM/themes/typewritten
  # Link simbolico al tema (de custom a main theme folder)
  ln -s "$ZSH_CUSTOM/themes/typewritten/typewritten.zsh-theme" "$ZSH_CUSTOM/themes/typewritten.zsh-theme"
  ln -s "$ZSH_CUSTOM/themes/typewritten/async.zsh" "$ZSH_CUSTOM/themes/async"
}

configurar_nvim(){
	
  echo "---------------------------------------------------"
  echo "----------------- Configurar nvim -----------------"
  echo "---------------------------------------------------"
  
  # Virtual environments for python
  wd=$(pwd)
  mkdir -p /home/$USER/.virtualenvs && cd /home/$USER/.virtualenvs
  python -m venv debugpy
  /home/$USER/.virtualenvs/debugpy/bin/pip3 install debugpy
  cd $wd

  curl -fLo /home/$USER/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim -c 'PlugInstall|q|q'
  nvim -c 'so ~/.config/nvim/init.vim|q'
  nvim -c 'PlugInstall|q|q'
  pip3 install neovim cpplint pynvim
}

configurar_tmux() {

    echo "----------------------------------------------"
    echo "------------ Configurar tmux -----------------"
    echo "----------------------------------------------"

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

configurar_dunst(){

  echo "---------------------------------------------------"
	echo "----------------- Configurar dunst ----------------"
	echo "---------------------------------------------------"

  # Eliminar proceso
  killall dunst
  # Establecer/actualizar fichero de configuracion
  dunst -config ~/.config/dunst/dunstrc &
}

configurar_grub(){

  echo "---------------------------------------------------"
  echo "-------------- Configurar tema grub ---------------"
  echo "---------------------------------------------------"
  
  # Create theme directory
  sudo mkdir -p /boot/grub/themes
  # Copy theme
  sudo cp -r grub/cottagecore /boot/grub/themes
  # Change theme
  sudo sed -i 's/GRUB_THEME=".*"/GRUB_THEME="\/boot\/grub\/themes\/cottagecore\/theme.txt"/' /etc/default/grub
  sudo sed -i 's/#GRUB_THEME=".*"/GRUB_THEME="\/boot\/grub\/themes\/cottagecore\/theme.txt"/' /etc/default/grub
  # Update config
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

instalar_spotify(){

  echo "---------------------------------------------------"
  echo "---------------- Instalar spotify -----------------"
  echo "---------------------------------------------------"
  
  yay -S spotify spicetify-cli
  sudo chmod a+wr /opt/spotify
  sudo chmod a+wr /opt/spotify/Apps -R
}


iniciar_spotify(){
	
  spotify &> /dev/zero &
  echo "Inicia sesión en tu spotify"
  echo "Presiona [Enter] una vez hayas iniciado sesión"
  
  while : ; do
  	read -s -N 1 -t 1 key
  	if [[ $key == $'\x0a' ]] ; then
  		break
  	fi
  done
  
  killall spotify
  
}

config_spicetify(){
	
  echo "---------------------------------------------------"
  echo "-------------- Configurar spicetify ---------------"
  echo "---------------------------------------------------"
  
  iniciar_spotify
  
  spicetify backup apply
  spicetify restore backup
  
  # Especificar tema
  # cd ~/.config/spicetify/Extensions && spicetify config extensions *.js && cd ~
  spicetify config current_theme Sleek color_scheme BladeRunner
  spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
  spicetify apply
}

config_spotify_adblock(){

  echo "---------------------------------------------------"
  echo "----------- Configurar spotify-adblock ------------"
  echo "---------------------------------------------------"
  
  # Instalar 
  yay -S make rust
  git clone https://github.com/abba23/spotify-adblock.git
  cd spotify-adblock
  make
  sudo make install
  cd ..
  sudo rm -r spotify-adblock
}

instalar_dependencias
eliminar_wallpapers
configurar_nvim
configurar_tmux
copiar_dotfiles
copiar_fuentes
copiar_servicios
instalar_caffeine
configurar_typewritten
configurar_dunst
configurar_grub
instalar_spotify
config_spicetify
config_spotify_adblock

