export PGPASSWORD=transitime
docker build -t transitime-server .
docker run --name transitime-db -e POSTGRES_PASSWORD=$PGPASSWORD -d postgres
docker run --name transitime --link transitime-db:postgres -p 8080:8080 -d transitime-server

