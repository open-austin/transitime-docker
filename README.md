# transitime-db

http://transitime-host.cloudapp.net/api/v1/key/f18a8240/agency/cap-metro/command/predictions?rs=803%7C4830

Things to make transitime go:

- Ubuntu
- sudo apt-get install git
- git clone https://github.com/walkeriniraq/transitime-db.git
- curl -sSL https://get.docker.com/ | sh  (i.e. install docker)
- ./go.sh

The go script will build the transitime container (takes a long time), start the postgres db, create the tables,
push the cap metro data into the db, create a default API key (f18a8240) and then start the server, connecting
it to the server's port 80.

If you want to run an instance of the transitime app, you can call:
./run_to_bash.sh

