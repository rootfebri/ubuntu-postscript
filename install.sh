#!/usr/bin/bash

pkg=(screen php jq zsh git gh redis-server php-predis php-pear php-common php-cli php-json php-xml php-zip php-curl php-bz2 php-bcmath php-calendar php-ctype php-dba php-dom php-exif php-ffi php-fileinfo php-ftp php-gd php-gmp php-iconv php-igbinary php-imagick php-imap php-intl php-ldap php-mbstring php-mysqli php-opcache  php-pdo php-pgsql php-phar php-posix php-readline php-redis php-shmop php-simplexml php-soap php-sockets  php-sqlite3 php-sysvmsg php-sysvsem php-sysvshm php-tokenizer php-xml php-xmlreader php-xmlwriter php-xsl  php-all-dev)
USE_PLUGINS="plugins=(aliases zsh-autosuggestions git bundler macos rake rbenv ruby)"
ZSHRC_FILE="$HOME/.zshrc"

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt -y update && sudo apt -y upgrade
sudo apt -y install screen -qq

# Install packages with error handling
function installPkg() {
  package="$1"
  echo "Installing $package..."
  if sudo apt -y install "$package" > /dev/null 2>&1; then
    echo "$package installed successfully."
    return 0
  else
    printf "Failed to install $package."
    return 1
  fi
}

for p in "${pkg[@]}"; do
  installPkg "$p"
done

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions plugin
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
# Install Oh My Zsh
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Prompt user to add aliases to .zshrc
echo "Adding aliases to $ZSHRC_FILE..."
{
  echo ""
  echo "alias vimrc='vim ~/.zshrc'"
  echo "alias loadrc='source ~/.zshrc'"
  echo "alias app='sudo apt -y'"
  echo "alias arm='sudo apt -y autoremove'"
} >> "$ZSHRC_FILE"

# Replace plugins line in .zshrc
if grep -q "^plugins=(git)$" "$ZSHRC_FILE"; then
  echo "Updating plugins in $ZSHRC_FILE..."
  sed -i.bak '/^plugins=(git)$/c'"$USE_PLUGINS" "$ZSHRC_FILE"
fi

# Change default shell to zsh
echo "Changing default shell to zsh..."
chsh -s "$(which zsh)" || echo "Failed to change shell. You may need to do this manually."

echo "Setup complete! Restart your terminal or run 'zsh' to use the new configuration."
