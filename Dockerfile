FROM centos:centos7
MAINTAINER T.Nakagawa <t.nakagawa@t.nakagawa.dummy.com>

ARG MAJOR_VERSION=3.0
ARG ZBX_VERSION=${MAJOR_VERSION}.27
ENV TERM=xterm ZBX_VERSION=${ZBX_VERSION} ZBX_SOURCES=${ZBX_SOURCES} \
    ZBX_TYPE=agent ZBX_DB_TYPE=none ZBX_OPT_TYPE=none
ENV TINI_VERSION v0.18.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini

COPY files/rpms/ /tmp/

# install zabbix agent
RUN yum -y localinstall /tmp/zabbix-agent-for-docker-host-3.0.27-1.el7.x86_64.rpm && \
  yum -y localinstall /tmp/zabbix-sender-3.0.27-1.el7.x86_64.rpm && \
  yum -y localinstall /tmp/zabbix-get-3.0.27-1.el7.x86_64.rpm && \
  yum -y clean all && \
  rm -rf /tmp/zabbix-agent-for-docker-host-3.0.27-1.el7.x86_64.rpm \
    /tmp/zabbix-sender-3.0.27-1.el7.x86_64.rpm \
    /tmp/zabbix-get-3.0.27-1.el7.x86_64.rpm && \
  chmod +x /sbin/tini

# DockerModule
# curl -O -L https://github.com/monitoringartist/zabbix-docker-monitoring/raw/gh-pages/centos7/${MAJOR_VERSION}/zabbix_module_docker.so
COPY files/zabbix_module_docker.so /var/lib/zabbix/modules/
COPY files/etc/zabbix/zabbix_agentd.d/docker-module.conf /etc/zabbix/zabbix_agentd.d/docker-module.conf

EXPOSE 10050/TCP

WORKDIR /var/lib/zabbix

VOLUME ["/etc/zabbix/zabbix_agentd.d", "/var/lib/zabbix/enc", "/var/lib/zabbix/modules"]

COPY ["docker-entrypoint.sh", "/usr/bin/"]

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/docker-entrypoint.sh"]
