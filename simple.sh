#!/usr/bin/env bash

# Path to .zshrc
ZSHRC_FILE="$HOME/.zshrc"

# List of packages to install
packages=(
  screen
  php
  jq
  zsh
  git
  gh
)

# Oh My Zsh plugins to configure
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

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt -y update && sudo apt -y upgrade

# Install required packages
echo "Installing packages..."
for pkg in "${packages[@]}"; do
  echo "Installing $pkg..."
  sudo apt -qq -y install "$pkg" || { echo "Failed to install $pkg"; exit 1; }
done

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions plugin
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "Cloning zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# Prompt user to add aliases to .zshrc
read -rp "Add aliases to .zshrc? (Y/n): " yn
if [[ "$yn" =~ ^[Yy]*$ || -z "$yn" ]]; then
  echo "Adding aliases to $ZSHRC_FILE..."
  {
    echo ""
    echo "alias vimrc='vim ~/.zshrc'"
    echo "alias loadrc='source ~/.zshrc'"
    echo "alias app='sudo apt -y'"
    echo "alias arm='sudo apt -y autoremove'"
  } >> "$ZSHRC_FILE"
else
  echo "Skipped adding aliases."
fi

# Replace plugins line in .zshrc
if grep -q "^plugins=(git)$" "$ZSHRC_FILE"; then
  echo "Updating plugins in $ZSHRC_FILE..."
  sed -i.bak '/^plugins=(git)$/c\
'"$USE_PLUGINS" "$ZSHRC_FILE"
else
  echo "plugins=(git) not found in $ZSHRC_FILE. Adding plugins configuration..."
  echo "$USE_PLUGINS" >> "$ZSHRC_FILE"
fi

# Change default shell to zsh
echo "Changing default shell to zsh..."
chsh -s "$(which zsh)" || echo "Failed to change shell. You may need to do this manually."

echo "Setup complete! Restart your terminal or run 'zsh' to use the new configuration."
