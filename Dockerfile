FROM fortytwoio/base-image:latest
MAINTAINER Thomas Fritz <thomas.fritz@forty-two.io>

ADD http://repo.mysql.com/mysql-apt-config_0.2.1-1debian7_all.deb /tmp/
RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config_0.2.1-1debian7_all.deb

RUN \
	DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
	DEBIAN_FRONTEND=noninteractive apt-get install -qqy --no-install-recommends mysql-server

ADD ./run.sh /root/run.sh
RUN chmod +x /root/run.sh

ADD ./my.cnf /root/my.cnf

EXPOSE 3306
VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/root/run.sh"]

