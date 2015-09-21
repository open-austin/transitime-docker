# transitime-db

Steps to get things kind of running from today

### set up the database

```
git clone git@github.com:walkeriniraq/transitime-db.git
docker build -t cap-metro .
# run this command and follow the prompts it asks to setup the db. use the password `transitime`
docker run -it --link cap-metro:postgres --rm cap-metro sh -c 'exec /bin/bash'
```

### import the capmetro data into the db. go to the transitime repo and use docker to run the load_db.sh script.

```
git clone git@github.com:walkeriniraq/transitime-core.git 
mvn install -DskipTests
docker build -t transitime .
docker run --link cap-metro:postgres -it transitime
root@b2f9a20799fb:/# java -Dtransitime.db.dbName=cap-metro -Dtransitime.db.dbType=postgresql -Dtransitime.db.dbUsername=postgres -Dtransitime.db.dbPassword=transitime -Dtransitime.hibernate.configFile=hibernate.cfg.xml -Dhibernate.connection.url=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/cap-metro -Dhibernate.connection.username=postgres -Dhibernate.connection.password=transitime -cp transitime.jar org.transitime.applications.GtfsFileProcessor -gtfsUrl "https://data.texas.gov/download/r4v4-vz24/application/zip"
```

###  run psql

```
docker run -it --link cap-metro:postgres --rm postgres sh -c 'exec /bin/bash'
root@128f177f8c3a:/# psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres -d cap-metro
#  verify the import was succesful
cap-metro=# select * from matches;
cap-metro=# update activerevisions set configrev=0, traveltimesrev=0 where id = 1;
```
