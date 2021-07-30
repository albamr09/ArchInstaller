#!/bin/bash

#Frameworks

.  ../utils/utilities.sh
.  ../config/config.sh
.  ../utils/particionado.sh

#Particionamiento

particionamiento(){

  echo "----------------------------------------------"
  echo "-------------- Particionamiento --------------"
  echo "----------------------------------------------"


  if [ -z "$DISCO_INSTALACION" ]; then
        mensaje_fallo "\$DISCO_INSTALACION no tiene un valor valido"
  fi

  partprobe -d -s $DISCO_INSTALACION &> /dev/zero && mensaje_exito "Comprobacion de dispositivo finalizada con exito" || mensaje_fallo "$DISCO_INSTALACION no existe"
  
  realizar_particionado $DISCO_INSTALACION
}

#Formatear particiones

formatear_particiones(){
  
  echo "----------------------------------------------"
  echo "----------- Formatear particiones ------------"
  echo "----------------------------------------------"


  mkfs.fat -F32 "$DISCO_INSTALACION"2 && mensaje_exito "Formateo exitoso de particion EFI" || mensaje_fallo "Fallo en el formateo de la particion EFI"
  
  if [ $USB -eq 1 ]; then
      mkfs.ext4 -O "^has_journal" "$DISCO_INSTALACION"4 && mensaje_exito "Formateo exitoso" || mensaje_fallo "Fallo en el formateo"
  else
      mkfs.ext4 "$DISCO_INSTALACION"4 && mensaje_exito "Formateo exitoso" || mensaje_fallo "Fallo en el formateo"
  fi

  mkswap "$DISCO_INSTALACION"3 && mensaje_exito "Formateo exitoso de swap" || mensaje_fallo "Fallo en el formateo de swap"
}

#Montar sistema de ficheros 

montar_sistema_ficheros(){
  
  echo "----------------------------------------------"
  echo "-------- Montar sistema de ficheros ----------"
  echo "----------------------------------------------"

  swapon "$DISCO_INSTALACION"3 && mensaje_exito "Activacion de swap correcta" || mensaje_fallo "Fallo en la activacion de swap"

  mount "$DISCO_INSTALACION"4 /mnt &> /dev/zero && mensaje_exito "Montado de sistema de ficheros correcto" || mensaje_fallo "Fallo durante el montado del sistema de ficheros"

  mkdir "/mnt/$DIRECTORIO_BOOT"
  mount "$DISCO_INSTALACION"2 "/mnt/$DIRECTORIO_BOOT" &> /dev/zero && mensaje_exito "Montado de particion EFI" || mensaje_fallo "Fallo durante el montado de la particion EFI"
}

#Instalar firmware

instalar_so(){

  echo "----------------------------------------------"
  echo "-------- Instalar sistema operativo ----------"
  echo "----------------------------------------------"

  pacstrap /mnt base base-devel linux linux-firmware networkmanager efibootmgr && mensaje_exito "Instalacion finalizada del SO" || mensaje_fallo "Fallo durante la instalacion del SO"

}

#Generar fstab

generar_fstab(){

  echo "----------------------------------------------"
  echo "-------------- Generar fstab -----------------"
  echo "----------------------------------------------"

  genfstab -U /mnt > /mnt/etc/fstab &> /dev/zero && mensaje_exito "Se ha generado fstab" || mensaje_fallo "Fallo durante la generacion de fstab"

}

#Chroot

configuracion_sistema(){
  
  echo "----------------------------------------------"
  echo "-------- Configuracion del sistema -----------"
  echo "----------------------------------------------"

  echo "----------------------------------------------"
  echo " + Chroot"
  echo "----------------------------------------------"

  cp -r ../install ../config ../utils /mnt
  arch-chroot /mnt ./install/chroot.sh && mensaje_exito "Se ha ejecutado el script chroot correctamente" || mensaje_fallo "Fallo durante la ejecucion del script de chroot"

  echo "----------------------------------------------"
  echo " + Limipeza"
  echo "----------------------------------------------"

  # Limipeza de chroot
  rm -r /mnt/install /mnt/config /mnt/utils &> /dev/zero && mensaje_exito "Se ha eliminado el script chroot" || mensaje_fallo "Fallo durante la eliminacion del script de chroot"
  
  # Copia de ficheros de configuracion
  copia_ficheros_config

  echo "----------------------------------------------"
  echo " + Fin de la instalacion"
  echo "----------------------------------------------"

  swapoff "$DISCO_INSTALACION"3 && mensaje_exito "Se ha desactivado el swap" || mensaje_fallo "Fallo al desactivar el swap"
  umount -a
}

copia_ficheros_config(){

  echo "----------------------------------------------"
  echo " + Copia de ficheros de post install"
  echo "----------------------------------------------"

  mkdir -p /mnt/Arch /mnt/Arch/install &> /dev/zero && mensaje_exito "Se ha creado la carpeta Arch" || mensaje_fallo "Fallo durante la creacion de la carpeta Arch"
  
  echo "----------------------------------------------"
  echo " + Copiar dotfiles"
  echo "----------------------------------------------"

  # Copiar ficheros post install
  cp -r post-install.sh /mnt/Arch/install &> /dev/zero && mensaje_exito "Se ha copiado post-install" || mensaje_fallo "Fallo durante la copia de post install"
  cp -r ../utils ../config /mnt/Arch &> /dev/zero && mensaje_exito "Se han copiado los scripts necesarios" || mensaje_fallo "Fallo durante la copia los scripts"
  # Copiar resources
  cp -r ../../resources/config /mnt/Arch &> /dev/zero && mensaje_exito "Se han copiado los ficheros de config" || mensaje_fallo "Fallo durante la copia de los ficheros de config"
  
  echo "----------------------------------------------"
  echo " + Fondos"
  echo "----------------------------------------------"
  mkdir -p /mnt/$DIR_FONDOS &> /dev/zero && mensaje_exito "Se ha creado el directorio de fondos" || mensaje_fallo "Fallo al crear el directorio de fondos"
  cp -r ../../resources/Wallpapers/* /mnt/$DIR_FONDOS &> /dev/zero && mensaje_exito "Se han copiado los fondos" || mensaje_fallo "Se han copiado los fondos"
}


#actualizacion_keys
#actualizacion_mirrors

particionamiento
formatear_particiones
montar_sistema_ficheros
instalar_so
generar_fstab
configuracion_sistema
