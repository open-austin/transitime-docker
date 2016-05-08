FROM maven:3.3
MAINTAINER Nathan Walker <nathan@rylath.net>

RUN apt-get update \
	&& apt-get install -y postgresql-client \
	&& apt-get install -y git-core

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.26
ENV TOMCAT_TGZ_URL http://ftp.heanet.ie/mirrors/www.apache.org/dist/tomcat/tomcat-8/v8.5.0/bin/apache-tomcat-8.5.0.tar.gz
ENV TOMCAT_TGZ_URL_ASC https://www.apache.org/dist/tomcat/tomcat-8/v8.5.0/bin/apache-tomcat-8.5.0.tar.gz.asc
RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL_ASC" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080

WORKDIR /


# RUN git clone https://github.com/scrudden/core.git /transitime-core
RUN git clone https://github.com/Transitime/core.git /transitime-core
WORKDIR /transitime-core/
RUN mvn install -DskipTests
WORKDIR /
RUN mkdir /usr/local/transitime
RUN mkdir /usr/local/transitime/db
RUN mkdir /usr/local/transitime/config
RUN mkdir /usr/local/transitimeTomcatConfig/

# Deploy core. The work horse of the system
RUN mv /transitime-core/transitime/target/Core.jar /usr/local/transitime/transitime.jar

# Deploy API which talks to core using RMI calls
RUN mv /transitime-core/transitimeApi/target/api.war /usr/local/tomcat/webapps

# Deploy webapp which is a UI based on the API
RUN mv /transitime-core/transitimeWebapp/target/web.war /usr/local/tomcat/webapps

RUN mv /transitime-core/transitime/target/classes/ddl_postgres*.sql /usr/local/transitime/db
RUN rm -rf /transitime-core
RUN rm -rf ~/.m2/repository


ADD bin/create_tables.sh create_tables.sh
ADD bin/create_api_key.sh create_api_key.sh
# ADD bin/check_db_up.sh check_db_up.sh

ADD bin/import_gtfs.sh import_gtfs.sh
ADD bin/connect_to_db.sh connect_to_db.sh
ADD bin/start_transitime.sh start_transitime.sh
RUN \
	sed -i 's/\r//' *.sh &&\
 	chmod 777 *.sh

ADD config/postgres_hibernate.cfg.xml /usr/local/transitime/config/hibernate.cfg.xml
ADD config/transitime.properties /usr/local/transitime/config/transitime.properties
ADD config/transitime.properties /usr/local/transitimeTomcatConfig/transitime.properties
ADD config/transiTimeConfig.xml /usr/local/transitime/config/transiTimeConfig.xml
CMD ["/start_transitime.sh"]

