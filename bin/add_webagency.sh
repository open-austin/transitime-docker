#!/usr/bin/env bash
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d $AGENCYNAME \
	-c "INSERT INTO webagencies(agencyid, active, dbencryptedpassword, dbhost, dbname, dbtype, dbusername, hostname) VALUES ('$AGENCYID', '1', '$PGPASSWORD', '$POSTGRES_PORT_5432_TCP_ADDR', '$AGENCYNAME','postgresql', 'postgres' , '127.0.0.1');"

