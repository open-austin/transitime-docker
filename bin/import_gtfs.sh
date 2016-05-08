#!/usr/bin/env bash
java \
	-Dtransitime.db.dbName=$AGENCYNAME \
	-Dtransitime.db.dbType=postgresql \
	-Dtransitime.db.dbUserName=postgres \
	-Dtransitime.db.dbPassword=$PGPASSWORD \
	-Dtransitime.core.agencyId=02 \
	-Dtransitime.hibernate.configFile=/usr/local/transitime/config/hibernate.cfg.xml \
	-Dhibernate.connection.url=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/$AGENCYNAME \
	-Dhibernate.connection.username=postgres \
	-Dhibernate.connection.password=$PGPASSWORD \
	-cp /usr/local/transitime/transitime.jar \
	org.transitime.applications.GtfsFileProcessor \
	-gtfsUrl $GTFSURL \
	-maxTravelTimeSegmentLength 400

psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-c "update activerevisions set configrev=0 where configrev = -1; update activerevisions set traveltimesrev=0 where traveltimesrev = -1;"

