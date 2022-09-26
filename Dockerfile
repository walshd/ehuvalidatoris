FROM busybox:latest AS vnu

RUN cd /tmp && \
    wget -O vnu.war.zip https://github.com/validator/validator/releases/download/20.6.30/vnu.war_20.6.30.zip && \
    unzip vnu.war.zip

FROM tomcat:8-jdk8 AS cssval

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install ant

RUN cd /tmp && \
    wget -O cssval.tar.gz https://github.com/w3c/css-validator/archive/refs/tags/cssval-20220105.tar.gz && \
    tar -zxf cssval.tar.gz && \
    cd css-validator-cssval-20220105 && \
    ant war

FROM tomcat:8-jre8

COPY --from=vnu /tmp/dist-war/vnu.war /usr/local/tomcat/webapps/html.war

COPY --from=cssval /tmp/css-validator-cssval-20220105/css-validator.war /usr/local/tomcat/webapps/css.war
