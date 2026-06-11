FROM maven:3.8.6-openjdk-11 AS build

WORKDIR /app

# पूरे प्रोजेक्ट को कंटेनर में कॉपी करना
COPY . .

# जावा फाइल्स को मैन्युअली कंपाइल करना और सही फोल्डर स्ट्रक्चर बनाना
RUN mkdir -p web/WEB-INF/classes
RUN javac -cp "web/WEB-INF/lib/*" -d web/WEB-INF/classes src/java/*.java src/java/db/*.java 2>/dev/null || \
    javac -d web/WEB-INF/classes src/java/*.java src/java/db/*.java

# अब टॉमकेट सर्वर में सिर्फ कंपाइल हुआ फाइनल माल डालना
FROM tomcat:9.0-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/web/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]
