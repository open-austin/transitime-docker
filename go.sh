export PGPASSWORD=transitime
docker build -t transitime-server .
docker run --name transitime-db -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres
docker run --rm --link transitime-db:postgres transitime-server ./create_tables.sh
docker run --rm --link transitime-db:postgres transitime-server ./import_cap_metro.sh
docker run --rm --link transitime-db:postgres transitime-server ./create_api_key.sh
docker run --name transitime --link transitime-db:postgres -p 80:8080 -d transitime-server

