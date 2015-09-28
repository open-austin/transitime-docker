#!/usr/bin/env bash
export PGPASSWORD=transitime
java \
	-Dtransitime.db.dbName=cap-metro \
	-Dtransitime.db.dbType=postgresql \
	-Dtransitime.db.dbUserName=postgres \
	-Dtransitime.db.dbPassword=$PGPASSWORD \
	-Dtransitime.core.agencyId=cap-metro \
	-Dtransitime.hibernate.configFile=/usr/local/transitime/hibernate.cfg.xml \
	-Dhibernate.connection.url=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/cap-metro \
	-Dhibernate.connection.username=postgres \
	-Dhibernate.connection.password=$PGPASSWORD \
	-cp /usr/local/transitime/transitime.jar \
	org.transitime.applications.GtfsFileProcessor \
	-gtfsUrl "https://data.texas.gov/download/r4v4-vz24/application/zip"

psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d cap-metro \
	-c "update activerevisions set configrev=0 where configrev = -1; update activerevisions set traveltimesrev=0 where traveltimesrev = -1;"

