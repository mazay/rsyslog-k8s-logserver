FROM alpine:latest
LABEL maintainer="Yevgeniy Valeyev <z.mazay@gmail.com>"

RUN apk --no-cache add rsyslog
COPY rsyslog.conf /etc/

EXPOSE 514/udp
EXPOSE 514/tcp

CMD ["rsyslogd", "-n"]
