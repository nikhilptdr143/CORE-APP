FROM tomcat:9.0-jdk11-openjdk-slim

# पुरानी फाइलों को साफ करना
RUN rm -rf /usr/local/tomcat/webapps/*

# फ्रंटएंड (JSP/HTML/CSS) को ROOT में कॉपी करना
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# जावा क्लासेस के लिए सही फोल्डर स्ट्रक्चर बनाना
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/db

# आपकी जावा फाइलों (Servlets) को कंपाइल करके सही जगह डालना
# यह लिनक्स सर्वर पर आपके पूरे कोड को खुद सेट कर देगा
RUN javac -cp /usr/local/tomcat/lib/servlet-api.jar:/usr/local/tomcat/lib/jsp-api.jar \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    ./src/java/db/*.x 2>/dev/null || \
    RUN javac -cp /usr/local/tomcat/lib/servlet-api.jar:/usr/local/tomcat/lib/jsp-api.jar \
    -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    ./src/java/*.java ./src/java/db/*.java

EXPOSE 8080
CMD ["catalina.sh", "run"]
