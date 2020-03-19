#!/usr/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if command -v ruby > /dev/null 2>&1 ; then
  printf "${YELLOW}Installing ruby dependencies...\n${NC}"
  bundle install
  printf "${YELLOW}Creating templates directory in ~/.crat/templates: ${NC}"
  mkdir ~/.crat/templates -p
  printf "${GREEN}✔\n${NC}"
  printf "${YELLOW}Copying program files to ~/.crat/lib: ${NC}"
  cp ./ ~/.crat/ -fR
  printf "${GREEN}✔\n${NC}"
  printf "${YELLOW}Setting up PATH, sourcing ~/.bashrc${NC}: "
  echo 'export PATH="$PATH:~/.crat/lib/"' >> ~/.bashrc
  source ~/.bashrc
  printf "${GREEN}✔\n${NC}"
  printf "${GREEN}DONE\n${NC}"
else
  printf "${RED}Ruby not found, install and try again.\n${NC}"
fi
