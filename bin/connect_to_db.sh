#!/usr/bin/env bash
export PGPASSWORD=transitime
psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_POST_5432_TCP_PORT" -U postgres -d cap-metro
