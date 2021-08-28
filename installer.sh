#!/bin/sh
##############################################################################################################
##
## Script Purpose:
##		Download and install IPK/DEB (Py2/Py3)
##
## Command: wget https://raw.githubusercontent.com/biko-73/openmultiboot/main/installer.sh -O - | /bin/sh
##
##############################################################################################################


##############################################################################################################
# Plugin	... Enter Manually
##############################################################################################################

MY_IPK_PY2="enigma2-plugin-extensions-openmultiboot_v2.6_all-Python2-20180202.ipk"
MY_IPK_PY3="enigma2-plugin-extensions-openmultiboot_v1.0_all-Python3-20210806.ipk"

MY_DEB_PY2="enigma2-plugin-extensions-openmultiboot_v1.0_all-Python2-20210806.deb"
MY_DEB_PY3="enigma2-plugin-extensions-openmultiboot_v1.0_all-Python3-20210806.deb"

PACKAGE_DIR='openmultiboot/main'

##############################################################################################################
# Auto ... Do not change
##############################################################################################################
MY_MAIN_URL="https://raw.githubusercontent.com/biko-73/"

PYTHON_VERSION=$(python -c 'import sys; print(sys.version_info[0])')

# Decide : which package ?
if which dpkg > /dev/null 2>&1; then
	if [ "$PYTHON_VERSION" -eq "2" ]; then
		MY_FILE=$MY_DEB_PY2
	else echo "333";
		MY_FILE=$MY_DEB_PY3
	fi;
	MY_URL=$MY_MAIN_URL$PACKAGE_DIR'/'$MY_FILE
else
	if [ "$PYTHON_VERSION" -eq "2" ]; then
		MY_FILE=$MY_IPK_PY2
	else echo "333";
		MY_FILE=$MY_IPK_PY3
	fi;
	MY_URL=$MY_MAIN_URL$PACKAGE_DIR'/'$MY_FILE
fi
MY_TMP_FILE="/tmp/"$MY_FILE


echo ''
echo '************************************************************'
echo '**                         STARTED                        **'
echo '************************************************************'
echo "**                 Uploaded by: Biko_73                   **"
echo "**  https://www.tunisia-sat.com/forums/threads/4120814/   **"
echo "************************************************************"
echo ''

# Remove previous file (if any)
rm -f $MY_TMP_FILE > /dev/null 2>&1

# Download package file
MY_SEP='============================================================='
echo $MY_SEP
echo 'Downloading '$MY_FILE' ...'
echo $MY_SEP
echo ''
wget -T 2 $MY_URL -P "/tmp/"

# Check download
if [ -f $MY_TMP_FILE ]; then
	# Install
	echo ''
	echo $MY_SEP
	echo 'Installation started'
	echo $MY_SEP
	echo ''
	if which dpkg > /dev/null 2>&1; then
		apt-get install --reinstall $MY_TMP_FILE -y
	else
		opkg install --force-reinstall $MY_TMP_FILE
	fi
	MY_RESULT=$?

	# Remove Installation file
	rm -f $MY_TMP_FILE > /dev/null 2>&1

	# Result
	echo ''
	echo ''
	if [ $MY_RESULT -eq 0 ]; then
		echo "   >>>>   SUCCESSFULLY INSTALLED   <<<<"
		echo ''
		echo "   >>>>         RESTARING         <<<<"
		if which systemctl > /dev/null 2>&1; then
			sleep 2; systemctl restart enigma2
		else
			init 4; sleep 4; init 3;
		fi
	else
		echo "   >>>>   INSTALLATION FAILED !   <<<<"
	fi;
	echo ''
	echo '**************************************************'
	echo '**                   FINISHED                   **'
	echo '**************************************************'
	echo ''
	exit 0
else
	echo ''
	echo "Download failed !"
	exit 1
fi

# ------------------------------------------------------------------------------------------------------------
