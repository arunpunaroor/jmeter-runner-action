FROM alpine:3.12.1

LABEL "maintainer" "Central QA"
LABEL "com.github.actions.name"="jmeter-runner-action"
LABEL "com.github.actions.description"="Run Apache JMeter Performance Tests, included with plugins"

ENV JMETER_VERSION "5.4.1"
ENV JMETER_HOME "/opt/apache/apache-jmeter-${JMETER_VERSION}"
ENV JMETER_BIN "${JMETER_HOME}/bin"
ENV PATH "$PATH:$JMETER_BIN"

COPY entrypoint.sh /entrypoint.sh
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh

RUN apk --no-cache add curl ca-certificates openjdk9-jre && \
    curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz --output /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    mkdir -p /opt/apache && \
    mv apache-jmeter-${JMETER_VERSION} /opt/apache && \
    rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    rm -rf ${JMETER_HOME}/docs && rm -rf ${JMETER_HOME}/printable_docs \
    rm -rf /var/cache/apk/* && \
    chmod a+x /entrypoint.sh
    chmod a+x /jmeter-plugin-install.sh


RUN /jmeter-plugin-install.sh

ENTRYPOINT [ "/entrypoint.sh" ]
