
# -------------------------------------------------------------------------------------
# Installation modifiable information
# -------------------------------------------------------------------------------------

DISCO_INSTALACION="/dev/sda"

USUARIO="alba"
IDIOMA="es_ES.UTF-8"
CODIFICACION="UTF-8"
KEYMAP="es"
DISPOSITIVO_GRUB=$DISCO_INSTALACION
USB=1                                           # USB = 0, indica no instalacion usb
ZONA_HORARIA="Europe/Madrid"

DIRECTORIO_BOOT="/boot"

DRIVERS="xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-nouveau"

# -------------------------------------------------------------------------------------
# GRUB configuration
# -------------------------------------------------------------------------------------

HOOKS_MKINITCPIO="(base udev block filesystems keyboard fsck)"
TARGET_GRUB_LEGACY="i386-pc"
TARGET_GRUB_EFI="x86_64-efi"
DIRECTORIO_GRUB_CONF="/boot/grub/grub.cfg"

# -------------------------------------------------------------------------------------
# Download packages after install
# -------------------------------------------------------------------------------------

TERMINAL="alacritty"
TWM="i3-wm i3status"
PAQUETES="nitrogen vim git wget neovim thunar python-pip zsh nano texlive-most"
PAQUETES_AUR="firefox;vscode;pamixer;pacman-contrib;ttf-font-awesome;surf;foxitreader"

# -------------------------------------------------------------------------------------
# Refresh mirrors
# -------------------------------------------------------------------------------------

KEYSERVER="hkp://keys.gnupg.net:80"
ARQUITECTURA="archlinux"

# -------------------------------------------------------------------------------------
# Wallpaper directory
# -------------------------------------------------------------------------------------

DIR_FONDOS="/home/$USUARIO/Wallpapers"
DIR_FONDOS_REG="\/home\/$USUARIO\/Wallpapers"
