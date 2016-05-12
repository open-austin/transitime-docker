# transitime-docker

http://transitime-host.cloudapp.net/api/v1/key/f18a8240/agency/cap-metro/command/predictions?rs=803%7C4830

Things to make transitime go:

- Ubuntu
- sudo apt-get install git
- git clone https://github.com/scrudden/transitime-docker.git
- curl -sSL https://get.docker.com/ | sh  (i.e. install docker)
- Configure Agency details in the go.sh script. Here you set the agency name, agency id (as in GTFS feed) and GTFS feed location
- ./go.sh

The go script will build the transitime container (takes a long time), start the postgres db, create the tables,
push the gtfs data into the db, create a default API key (f18a8240) and then start the api service and web user interface service. 

To view web interface
```
http://[ipaddress]:8080/web
```
To view api
```
http://[ipaddress]:8080/api
```

You can get the ip address by running
```
docker-machine ip [machine name]

docker-machine ip default
```

If you want to run an instance of the transitime app, you can call:
./run_to_bash.sh

