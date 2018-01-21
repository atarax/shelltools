#!/bin/bash

# colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'


# download and install z
Z_LOCATION=/usr/local/bin/z.sh
if [ ! -f $Z_LOCATION ] ; then
  printf "${YELLOW}Installing Z...${NO_COLOR}\n"
  curl https://raw.githubusercontent.com/rupa/z/master/z.sh > z.sh
  chmod +x z.sh && sudo mv z.sh /usr/local/bin
fi


# install things, powerline-fonts, needed for agnoster-theme,
# zsh, and curl to be able to install 
sudo apt-get install --yes fonts-powerline zsh curl 


# backup old .zshrc
ZSH_RC_LOCATION=$HOME/.zshrc
if [ -f $ZSH_RC_LOCATION  ]; then
  DATE=`date '+%Y-%m-%dT%H:%M:%S'`
  BACKUP_ZSHRC="${HOME}/.zshrc-backup-${DATE}"

  printf "${YELLOW}Backing up old .zshrc to ${BACKUP_ZSHRC}...${NO_COLOR}\n"
  mv $ZSH_RC_LOCATION $BACKUP_ZSHRC
fi


# install oh-my-zsh if necessary
if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi
if [ ! -d "$ZSH" ]; then
  printf "${RED}oh-my-zsh is not installed, exit zsh after it's installation!${NO_COLOR}\n"
  sleep 5
  printf "${YELLOW}Installing oh-my-zsh...${NO_COLOR}\n"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi


# copy new .zshrc
printf "${YELLOW}Copying .zshrc from repo to home...${NO_COLOR}\n"
cp zshrc ${ZSH_RC_LOCATION}


# done
printf "${YELLOW}Please log out and in again for changes to take effect!...${OLD_ZSHRC}${NO_COLOR}\n"
