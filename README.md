# zabbix-agent-for-docker-host
Zabbix Agent Container for Docker host.  

# How to use this image

## Start `zabbix-agent-for-docker-host`

Start a Zabbix agent container as follows:
```console
$ docker run --name some-zabbix-agent  -d --p10050:10050 -u 0 \
  -c 1024 -m 64M --memory-swap=-1 \
  --privileged \
  -v /proc:/dockerhost/proc:ro \
  -v /sys:/sys:ro \
  -v /dev:/dockerhost/dev:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e ZBX_HOSTNAME="some-hostname" \
  -e ZBX_SERVER_HOST="some-zabbix-server" \
  tnpiscidc/zabbix-agent-for-docker-host
```


# Environment Variables
When you start the zabbix-agent image, you can adjust the configuration of the Zabbix agent by passing one or more environment variables on the docker run command line.

Please see below for details.
https://github.com/zabbix/zabbix-docker/blob/3.0/agent/centos/README.md#environment-variables


# References
https://github.com/zabbix/zabbix-docker
https://github.com/monitoringartist/zabbix-docker-monitoring
