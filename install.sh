#!/usr/bin/bash

pkg=(
    php
    jq
    zsh
    git gh
    redis-server
    php-predis
    php-dev
    php-pear
    php-common
    php-cli
    php-json
    php-xml
    php-zip
    php-curl
    php-bz2
    php-fpm
    php-bcmath
    php-calendar
    php-ctype
    php-dba
    php-dom
    php-exif
    php-ffi
    php-fileinfo
    php-filter
    php-ftp
    php-gd
    php-gmp
    php-iconv
    php-igbinary
    php-imagick
    php-imap
    php-intl
    php-ldap
    php-lz4
    php-mbstring
    php-mysqli
    php-opcache
    php-openssl
    php-pdo
    php-pgsql
    php-phar
    php-posix
    php-readline
    php-redis
    php-session
    php-shmop
    php-simplexml
    php-soap
    php-sockets
    php-sodium
    php-sqlite3
    php-sysvmsg
    php-sysvsem
    php-sysvshm
    php-tokenizer
    php-xml
    php-xmlreader
    php-xmlwriter
    php-xsl
    php-zip
    php-zlib
    php-sqlite3
    php-all-dev
)

sudo apt -y update
sudo apt -y upgrade

for pkg in "${pkg[@]}"; do
    echo "Installing $pkg..."
    # install quietly
    sudo apt -qq -y install $pkg
done
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

read -p 'Add alias into .zshrc? y/n' yn
if [[ $yn == [Yy]* ]]; then
    echo "alias vimrc='vim ~/.zshrc'" >>~/.zshrc
    echo "alias loadrc='source ~/.zshrc'" >>~/.zshrc
    echo "alias app='sudo apt -y'" >>~/.zshrc
    echo "alias arm='sudo apt -y autoremove'" >>~/.zshrc
    echo "alias art='! [ -s artisan ] && echo \"Not in laravel root project\" || chmod +x artisan && ./artisan'" >>~/.zshrc
    echo 'function art { if ! [ -s artisan ]; then echo "Not in laravel root project"; else; chmod +x artisan && ./artisan "$@"; fi }' >>~/.zshrc
fi
