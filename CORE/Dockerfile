FROM tomcat:9.0-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

# नेटबीन्स के 'web' फोल्डर के अंदर की सारी चीज़ों को सीधे ROOT में कॉपी कर रहे हैं
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# अगर जावा की क्लासेस (Classes) हैं, तो उन्हें भी सही जगह सेट कर रहे हैं
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes
COPY ./src/java/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]
