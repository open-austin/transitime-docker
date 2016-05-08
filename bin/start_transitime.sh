#!/usr/bin/env bash
export PGPASSWORD=transitime
export AGENCYNAME=IR
/usr/local/tomcat/bin/startup.sh
java \
    -Dtransitime.hibernate.configFile=/usr/local/transitime/config/hibernate.cfg.xml \
    -Dhibernate.connection.url=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/$AGENCYNAME \
    -Dhibernate.connection.username=postgres \
    -Dhibernate.connection.password=$PGPASSWORD \
    -Dtransitime.configFiles=/usr/local/transitime/config/transiTimeConfig.xml \
    -cp /usr/local/transitime/transitime.jar \
	org.transitime.applications.Core

