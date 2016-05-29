FROM maven:3.3-jdk-7
MAINTAINER Nathan Walker <nathan@rylath.net>

ENV TRANSITIMECORE /transitime-core
ENV PGPASSWORD=transitime
ENV AGENCYNAME=CAPMETRO
ENV AGENCYID=1
ENV GTFS_URL="https://data.texas.gov/download/r4v4-vz24/application/zip"
ENV GTFSRTVEHICLEPOSITIONS="https://data.texas.gov/download/eiei-9rpf/application/octet-stream"

RUN apt-get update \
	&& apt-get install -y postgresql-client \
	&& apt-get install -y git-core \
	&& apt-get install -y vim

RUN apt-get install -y tomcat7

# Install json parser so we can read API key for CreateAPIKey output

RUN wget http://stedolan.github.io/jq/download/linux64/jq

RUN chmod +x ./jq

RUN cp jq /usr/bin/

RUN git clone https://github.com/scrudden/core.git /transitime-core

#RUN git clone https://github.com/Transitime/core.git /transitime-core

WORKDIR /transitime-core

RUN git checkout kalman_predictions

#RUN git checkout shade_build_upstream

RUN mvn install -DskipTests

WORKDIR /
RUN mkdir /usr/local/transitime
RUN mkdir /usr/local/transitime/db
RUN mkdir /usr/local/transitime/config
RUN mkdir /usr/local/transitime/logs
RUN mkdir /usr/local/transitimeTomcatConfig/

# Deploy core. The work horse of transiTime.
RUN cp /transitime-core/transitime/target/*.jar /usr/local/transitime/

# Deploy API which talks to core using RMI calls.
RUN cp /transitime-core/transitimeApi/target/api.war  /var/lib/tomcat7/webapps/

# Deploy webapp which is a UI based on the API.
RUN cp /transitime-core/transitimeWebapp/target/web.war  /var/lib/tomcat7/webapps/

RUN cp /transitime-core/transitime/target/classes/ddl_postgres*.sql /usr/local/transitime/db

# RUN rm -rf /transitime-core
# RUN rm -rf ~/.m2/repository

# Scripts required to start transiTime. These are in the order they need to be run.
ADD bin/check_db_up.sh check_db_up.sh
ADD bin/generate_sql.sh generate_sql.sh
ADD bin/create_tables.sh create_tables.sh
ADD bin/create_api_key.sh create_api_key.sh
ADD bin/create_webagency.sh create_webagency.sh
ADD bin/import_gtfs.sh import_gtfs.sh
ADD bin/start_transitime.sh start_transitime.sh
ADD bin/get_api_key.sh	get_api_key.sh

# Handy utility to allow you connect directly to database
ADD bin/connect_to_db.sh connect_to_db.sh

# RUN ./generate_sql.sh

RUN \
	sed -i 's/\r//' *.sh &&\
 	chmod 777 *.sh

ADD config/postgres_hibernate.cfg.xml /usr/local/transitime/config/hibernate.cfg.xml
ADD config/transitime.properties /usr/local/transitime/config/transitime.properties
ADD config/transitime.properties /usr/local/transitimeTomcatConfig/transitime.properties
ADD config/transiTimeConfig.xml /usr/local/transitime/config/transiTimeConfig.xml

EXPOSE 8080

CMD ["/start_transitime.sh"]

