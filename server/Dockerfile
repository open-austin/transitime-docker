FROM tomcat:8-jre8
MAINTAINER Nathan Walker <nathan@rylath.net>

ADD server-scripts/create_tables.sh create_tables.sh

RUN apt-get update \
	&& apt-get install -y postgresql-client \
	&& apt-get install -y git-core

ENV MAVEN_VERSION 3.3.3

RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

RUN git clone https://github.com/walkeriniraq/transittime-core.git && cd transittime-core && git checkout cap-metro && mvn install -DskipTests


