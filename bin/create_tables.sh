#!/usr/bin/env bash
export PGPASSWORD=transitime
createdb -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres cap-metro
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d cap-metro \
	-f /usr/local/transitime/db/ddl_postgres_org_transitime_db_structs.sql
psql \
	-h "$POSTGRES_PORT_5432_TCP_ADDR" \
	-p "$POSTGRES_PORT_5432_TCP_PORT" \
	-U postgres \
	-d cap-metro \
	-f /usr/local/transitime/db/ddl_postgres_org_transitime_db_webstructs.sql
