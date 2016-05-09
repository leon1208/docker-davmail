FROM debian:jessie
MAINTAINER jberrenberg v0.5

RUN DEBIAN_FRONTEND=noninteractive ;\
  apt-get update && apt-get install -y --no-install-recommends \
  default-jre \
  wget && \
  apt-get clean && \
  rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN groupadd -r davmail && \
  useradd -r -g davmail davmail

RUN mkdir /usr/local/davmail && \
  wget -qO - http://downloads.sourceforge.net/project/davmail/davmail/4.7.2/davmail-linux-x86_64-4.7.2-2427.tgz | tar -C /usr/local/davmail --strip-components=1 -xvz && \
  mkdir /var/log/davmail && \
  chown davmail:davmail /var/log/davmail -R

COPY davmail.sh /usr/local/bin/
COPY davmail.properties /etc/davmail/

# VOLUME        /etc/davmail

# EXPOSE        1080
# EXPOSE        1143
# EXPOSE        1389
# EXPOSE        1110
# EXPOSE        1025

EXPOSE        143
EXPOSE        110
EXPOSE        25

WORKDIR       /usr/local/davmail

USER davmail
ENTRYPOINT    ["/usr/local/bin/davmail.sh"]
