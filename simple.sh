#!/usr/bin/bash

ZSHRC_FILE="$HOME/.zshrc"
pkg=(
    screen
    php
    jq
    zsh
    git
    gh
)

sudo apt -y update
sudo apt -y upgrade

USE_PLUGINS="plugins=(
  aliases
  zsh-autosuggestions
  git
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
)"

for pkg in "${pkg[@]}"; do
    echo "Installing $pkg..."
    # install quietly
    sudo apt -qq -y install $pkg
done

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

read -p 'Add alias into .zshrc? Y/n' yn
if [[ $yn == [Yy]* || -z $yn ]]; then
  echo "" >> ~/.zshrc
  echo "alias vimrc='vim ~/.zshrc'" >> "$ZSHRC_FILE"
  echo "alias loadrc='source ~/.zshrc'" >> "$ZSHRC_FILE"
  echo "alias app='sudo apt -y'" >> "$ZSHRC_FILE"
  echo "alias arm='sudo apt -y autoremove'" >> "$ZSHRC_FILE"
fi

sed -i.bak '/^plugins=(git)$/c\
'"$USE_PLUGINS" "$ZSHRC_FILE"

chsh -s $(which zsh)
