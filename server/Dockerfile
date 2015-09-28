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
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

EXPOSE 8080

WORKDIR /

RUN \
        git clone https://github.com/walkeriniraq/transittime-core.git && \
        cd transittime-core && \
        git checkout cap-metro && \
        mvn install -DskipTests && \
        cd / && \
        mkdir /usr/local/transitime && \
        mkdir /usr/local/transitime/db && \
        mv /transittime-core/transitime/target/transitime.jar /usr/local/transitime && \
        mv /transittime-core/transitimeApi/target/api.war /usr/local/tomcat/webapps && \
        mv /transittime-core/transitime/target/classes/ddl_postgres*.sql /usr/local/transitime/db && \
        rm -rf /transitime-core && \
        rm -rf ~/.m2/repository

ADD bin/create_tables.sh create_tables.sh
ADD bin/create_api_key.sh create_api_key.sh
ADD bin/import_cap_metro.sh import_cap_metro.sh
ADD bin/connect_to_db.sh connect_to_db.sh
ADD bin/start_transitime.sh start_transitime.sh
ADD config/postgres_hibernate.cfg.xml /usr/local/transitime/hibernate.cfg.xml
ADD config/transitime.properties /usr/local/transitime/transitime.properties

CMD ["/start_transitime.sh"]

