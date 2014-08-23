FROM fortytwoio/base-image:latest
MAINTAINER Thomas Fritz <thomas.fritz@forty-two.io>

RUN apt-get update -qq && \
	apt-get install -qqy --no-install-recommends \
	gettext-base \
	mysql-server

ADD ./run.sh /root/run.sh
RUN chmod +x /root/run.sh

ADD ./my.cnf /root/my.cnf

EXPOSE 3306
VOLUME ["/var/lib/mysql"]

CMD ["/root/run.sh"]

