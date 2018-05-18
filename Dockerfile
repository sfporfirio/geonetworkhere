FROM tomcat:8.0-jre8

RUN apt-get update && apt-get install -y dos2unix

#Environment variables
ENV GN_FILE geonetwork.war
ENV DATA_DIR=$CATALINA_HOME/webapps/geonetwork/WEB-INF/data
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -server -Xms512m -Xmx2024m -XX:NewSize=512m -XX:MaxNewSize=1024m -XX:+UseConcMarkSweepGC"
ENV GN_VERSION 3.4.2
ENV GN_DOWNLOAD_MD5 e0ff34ab3995b3a8107f3c3c78f7294a

WORKDIR $CATALINA_HOME/webapps

COPY ./geonetwork.war $GN_FILE

RUN mkdir -p geonetwork && \
	unzip -e $GN_FILE -d geonetwork && \
	rm $GN_FILE

COPY ./docker-entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]
RUN dos2unix /entrypoint.sh && apt-get --purge remove -y dos2unix && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]