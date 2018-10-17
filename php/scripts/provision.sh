#!/usr/bin/env bash

OS_CODENAME=`grep "VERSION=" /etc/os-release | sed -rn 's/.*\(([^\)]+)\).*/\1/p'`

mkdir -p ${APP_ROOT} /home/www-data && \
    chown www-data: ${APP_ROOT} /home/www-data && \
    usermod -d /home/www-data www-data

apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gnupg \
    ca-certificates \
    build-essential \
    apt-transport-https

# Install composer
wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/bin/composer && \
    chmod +rx/usr/bin/composer

echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

# Install dependencies
apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    sqlite3 \
    redis-tools \
    yarn

# Install Git LFS
wget https://packagecloud.io/github/git-lfs/packages/debian/${OS_CODENAME}/git-lfs_${GITLFS_VERSION}_amd64.deb/download -O git-lfs.deb \
    && dpkg -i git-lfs.deb \
    && rm git-lfs.deb

/scripts/install_php_extension.sh --cleanup \
    amqp apcu bcmath gettext intl mcrypt opcache \
    pdo_dblib pdo_sqlite pdo_pgsql pgsql \
    redis mongodb memcached imagick \
    shmop sockets sysvmsg sysvsem sysvshm wddx xml xsl zip ldap \
    && a2enmod rewrite ssl headers

# Install nodejs
case ${NODE_VESION} in
    10)
        curl --tlsv1 -ksL https://deb.nodesource.com/setup_10.x | bash - && \
            apt-get install -y nodejs
        ;;
esac

apt-get remove --purge -y build-essential
rm -rf /var/lib/apt/lists/*
