#!/bin/bash

# install powerline-fonts, needed for agnoster-theme
sudo apt-get install fonts-powerline

# colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

# backup old .zshrc if exists
OLD_ZSHRC=$HOME/.zshrc

if [ -f $OLD_ZSHRC  ]; then
  DATE=`date '+%Y-%m-%dT%H:%M:%S'`
  BACKUP_ZSHRC="${HOME}/.zshrc-backup-${DATE}"

  echo -e "${YELLOW}Backing up old .zshrc to $BACKUP_ZSHRC${NO_COLOR}..."
  mv $OLD_ZSHRC $BACKUP_ZSHRC
fi

echo -e "${YELLOW}Copying .zshrc from repo to ${OLD_ZSHRC}${NO_COLOR}..."
cp .zshrc ${OLD_ZSHRC}

# install zsh and oh-my-zsh
sudo apt-get install --yes zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


