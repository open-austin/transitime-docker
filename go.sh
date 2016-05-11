export PGPASSWORD=transitime

export AGENCYNAME=IR

export GTFSURL="http://www.transportforireland.ie/transitData/google_transit_irishrail.zip"
docker build -t transitime-server .

docker run --name transitime-db -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres

docker run --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./check_db_up.sh

docker run --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_tables.sh

docker run --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME -e GTFSURL=$GTFSURL transitime-server ./import_gtfs.sh

docker run --rm --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME transitime-server ./create_api_key.sh

docker run --rm -it --link transitime-db:postgres -e PGPASSWORD=$PGPASSWORD -e AGENCYNAME=$AGENCYNAME -p 8080:8080 transitime-server /bin/bash