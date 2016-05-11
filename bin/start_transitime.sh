#!/usr/bin/env bash
export PGPASSWORD=transitime
export AGENCYNAME=IR
export AGENCYID=02

# This is to substitute into config file the env values
sed -i s/"POSTGRES_PORT_5432_TCP_ADDR"/"$POSTGRES_PORT_5432_TCP_ADDR"/g /usr/local/transitime/config/*
sed -i s/"POSTGRES_PORT_5432_TCP_PORT"/"$POSTGRES_PORT_5432_TCP_PORT"/g /usr/local/transitime/config/*
sed -i s/"PGPASSWORD"/"$PGPASSWORD"/g /usr/local/transitime/config/*
sed -i s/"AGENCYNAME"/"$AGENCYNAME"/g /usr/local/transitime/config/*

cp /usr/local/transitime/config/transitime.properties /usr/local/transitimeTomcatConfig/transitime.properties

java -Dtransitime.configFiles=/usr/local/transitime/config/transiTimeConfig.xml \
	-Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ \
   -cp /usr/local/transitime/transitime.jar \
	org.transitime.applications.Core /dev/null 2>&1 &

/usr/local/tomcat/bin/startup.sh
