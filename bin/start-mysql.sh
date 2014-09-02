#!/usr/bin/env bash
set -eu # exit on error or undefined variable

# Defaults
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
export MYSQL_USER=${MYSQL_USER:-""}
export MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}
export MYSQL_DATABASE=${MYSQL_DATABASE:-""}
export MYSQL_RAMDISK=${MYSQL_RAMDISK:-""}
export MYSQL_SET_KEYBUF=${MYSQL_SET_KEYBUF:-"128M"}
export MYSQL_SET_QCACHE=${MYSQL_SET_QCACHE:-"32M"}


# Ramdisk?
if [[ ! -z $MYSQL_RAMDISK ]]; then
    echo "Initializing ramdisk: ${MYSQL_RAMDISK} Mb"
    mkdir -p /var/lib/mysql
    mount -t tmpfs -o size="${MYSQL_RAMDISK}m" tmpfs /var/lib/mysql
fi


# Permissions
chown -R mysql:mysql /var/lib/mysql
chmod -R ug+rwX,o-rwx /var/lib/mysql
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Config file template from environment variables
envsubst < /etc/mysql/my.cnf.tpl > /etc/mysql/my.cnf

# Initialize MySQL data directory
mysql_install_db --user mysql $@ > /dev/null


# Execute SQL commands
function mysql_init_commands(){
    echo "FLUSH PRIVILEGES;"
    [[ ! -z $MYSQL_ROOT_PASSWORD ]] \
        && echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;"
    [[ ! -z $MYSQL_DATABASE ]] \
        && echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
    [[ ! -z $MYSQL_USER ]] \
        && echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
}

mysql_init_commands | /usr/sbin/mysqld --user=mysql --bootstrap --verbose=0 $@


# Launch
exec /usr/sbin/mysqld --user=mysql $@
