#!/bin/bash

# colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

ZSH_RC_LOCATION=$HOME/.zshrc

# install things, powerline-fonts, needed for agnoster-theme,
# zsh, and curl to be able to install 
sudo apt-get install --yes fonts-powerline zsh curl 

if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi
if [ ! -d "$ZSH" ]; then
  printf "${RED}oh-my-zsh is not installed, exit zsh after it's installation!${NO_COLOR}\n"
  sleep 5
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

printf "${YELLOW}Copying .zshrc from repo to ${OLD_ZSHRC}${NO_COLOR}...\n"
cp .zshrc ${ZSH_RC_LOCATION}

printf "${YELLOW}Please log out and in again for changes to take effect!${OLD_ZSHRC}${NO_COLOR}...\n"
