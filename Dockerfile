FROM alpine:3.19.1
LABEL maintainer="Yevgeniy Valeyev <z.mazay@gmail.com>"

# hadolint ignore=DL3018
RUN apk --no-cache add rsyslog
COPY rsyslog.conf /etc/

EXPOSE 514/udp
EXPOSE 514/tcp

CMD ["rsyslogd", "-n"]
