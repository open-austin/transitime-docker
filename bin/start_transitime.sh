#!/usr/bin/env bash

# This is to substitute into config file the env values
sed -i s#"POSTGRES_PORT_5432_TCP_ADDR"#"$POSTGRES_PORT_5432_TCP_ADDR"#g /usr/local/transitime/config/*
sed -i s#"POSTGRES_PORT_5432_TCP_PORT"#"$POSTGRES_PORT_5432_TCP_PORT"#g /usr/local/transitime/config/*
sed -i s#"PGPASSWORD"#"$PGPASSWORD"#g /usr/local/transitime/config/*
sed -i s#"AGENCYNAME"#"$AGENCYNAME"#g /usr/local/transitime/config/*
sed -i s#"GTFSRTVEHICLEPOSITIONS"#"$GTFSRTVEHICLEPOSITIONS"#g /usr/local/transitime/config/*

cp /usr/local/transitime/config/transitime.properties /usr/local/transitimeTomcatConfig/transitime.properties

rmiregistry &

#set the API as an environment variable so we can set in JSP of template/includes.jsp in the transitime webapp
export APIKEY=$(/get_api_key.sh)

# make it so we can also access as a system property in the JSP
export JAVA_OPTS="$JAVA_OPTS -Dtransitime.apikey=$(/get_api_key.sh)"

echo JAVA_OPTS $JAVA_OPTS

/usr/local/tomcat/bin/startup.sh

java -Dtransitime.configFiles=/usr/local/transitime/config/transiTimeConfig.xml -Dtransitime.core.agencyId=$AGENCYID -Dtransitime.logging.dir=/usr/local/transitime/logs/ -jar $TRANSITIMECORE/transitime/target/Core.jar -configRev 0 /dev/null 2>&1



