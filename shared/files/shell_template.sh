#!/bin/bash

# Colors
green_bold="\033[1;32;49m"
red_bold="\033[1;31;49m"
normal="\033[0m"

printf "${normal}\n\n############################################################################${normal}\n"
printf "${normal}\t\t[BUILDING] PYTHON $PYTHON_VERSION FROM SOURCE ${normal}\n"
printf "${normal}############################################################################${normal}\n"

printf "${green_bold}[PYTHON]${normal} - Executing: ${red_bold}'/vagrant_data/config.py'  ${normal}\n"