
#!/bin/bash

# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

C1_NAME="cms-dev"
CMS_EXPORTS="/home/ubuntu/${C1_NAME}/exports"

printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[INSTALLING] DJANGO CMS (On Container: ${C1_NAME})${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[SOURCING]${normal} - Sourcing: ${red_bold}Variables at '${CMS_EXPORTS}' ${normal}\n"
. ${CMS_EXPORTS} 


printf "${green_bold}[CREATING]${normal} - Django CMS Dir: ${red_bold}at: '${CMS_USER_DIR}${C1_NAME}/${CMS_PROJECT_DIR}' (On ${C1_NAME}.sh)${normal}\n"
mkdir -p ${CMS_USER_DIR}${C1_NAME}/${CMS_PROJECT_DIR}

printf "${green_bold}[CD]${normal} - to: ${red_bold}'${CMS_USER_DIR}${C1_NAME}/${CMS_PROJECT_DIR}/' 
(On ${C1_NAME}.sh) ${normal}\n"
cd ${CMS_USER_DIR}${C1_NAME}/${CMS_PROJECT_DIR}/

printf "${green_bold}[ENABLING]${normal}   - Virtualenv:${red_bold} 'source${USER_DIR}${VENV_NAME}/bin/activate'${normal}\n"
source $USER_DIR$VENV_NAME/bin/activate

printf "${green_bold}[CREATING]${normal} - Django CMS Project: ${red_bold}Name: '${CMS_PROJECT_NAME}' (On ${C1_NAME}.sh) - THIS WILL TAKE A FEW MINS${normal}\n"
djangocms ${CMS_PROJECT_NAME} > /dev/null 2>&1

printf "${green_bold}[PERMISSIONS]${normal} - Adjusting: ${red_bold}'${USER_DIR}' (On ${C1_NAME}.sh)${normal}\n"
sudo chown damt -R ${USER_DIR} > /dev/null 2>&1

#printf "${green_bold}[STARTING]${normal} - Django CMS Server: ${red_bold}Command: python manage.py runserver ${CMS_IP}:8000 (On ${C1_NAME}.sh)${normal}\n"
# python manage.py runserver ${CMS_IP}:8000
# nohup python manage.py runserver 0.0.0.0:8000 & # Does not works
# python manage.py runserver 10.10.20.221:8000 > /dev/null 2>&1 &   # Does not works

# https://stackoverflow.com/questions/29709790/scripts-with-nohup-inside-dont-exit-correctly
# nohup python manage.py runserver 10.10.20.131:8000 1>/dev/null 2>/dev/null &