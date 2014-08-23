docker-mysql-server
===================

## Usage
```
docker pull fortytwoio/mysql-server
docker run -d -e "MYSQL_ROOT_PASSWORD=changeme" -P --volumes-from dbdata fortytwoio/mysql-server
```

Docker Hub [fortytwoio/mysql-server](https://registry.hub.docker.com/u/fortytwoio/mysql-server/)


## Environment Variables

* `MYSQL_ROOT_PASSWORD`: Sets this password for the `root` DB user which has ultimate access. Optional.
* `MYSQL_DATABASE`: Create a database with the provided name and `utf8_general_ci`. Optional.
* `MYSQL_USER`: Create this user and grant with the access to `$MYSQL_DATABASE`. Optional.
* `MYSQL_PASSWORD`: Password for the user to be created

Fine-tuning:

* `MYSQL_RAMDISK`: Run MySQL in a ramdisk. Value sets the disk size in megabytes. Optional. *NOTE*: Requires `docker run --privileged`
* `MYSQL_SET_KEYBUF=128M`: Key buffer size
* `MYSQL_SET_QCACHE=32M`: Query cache size

## Thanks to [kolypto/docker-mysql](https://github.com/kolypto/docker-mysql)
