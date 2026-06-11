FROM tomcat:9.0-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

COPY . /usr/local/tomcat/webapps/ROOT/

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes
COPY ./build/web/WEB-INF/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]
