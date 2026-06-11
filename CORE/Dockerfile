FROM maven:3.8.6-openjdk-11 AS build

WORKDIR /app

# पूरे प्रोजेक्ट को कॉपी करना
COPY . .

# सही फोल्डर स्ट्रक्चर तैयार करना
RUN mkdir -p web/WEB-INF/classes

# लिनक्स का जादुई कमांड: यह पूरे प्रोजेक्ट में जहाँ भी .java फाइलें छुपी होंगी, 
# उन्हें ढूंढकर अपने आप बिना किसी पाथ एरर के कंपाइल कर देगा!
RUN find . -name "*.java" > sources.txt && \
    javac -cp "web/WEB-INF/lib/*:web/WEB-INF/*" -d web/WEB-INF/classes @sources.txt

# अब फाइनल कंपाइल माल टॉमकेट में डालना
FROM tomcat:9.0-jdk11-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/web/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]
