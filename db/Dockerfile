FROM postgres
MAINTAINER Nathan Walker <nathan@rylath.net>

ADD sql /transitime-sql/
ADD generate.sh /generate.sh

ENTRYPOINT '/generate.sh'

# RUN psql -f

