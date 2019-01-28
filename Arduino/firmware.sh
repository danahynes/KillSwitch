VERSION_NUMBER=$(grep "VERSION_NUMBER=" "version.txt" | cut -d "=" -f2)
VERSION_BUILD=$(grep "VERSION_BUILD=" "version.txt" | cut -d "=" -f2)
cd .pioenvs/uno
cp firmware.hex "../../firmware-${VERSION_NUMBER}-${VERSION_BUILD}.hex"
