# Docker compose
Repo for my docker-compose files

Each application's files are on a separate branch

## Notes
### User-defined network
Applications may use a external custom network as follows:

```
networks:
  br:
    external: true
    name: ${DOCKER_NETWORK:-br}
```

create it manually by `docker network create ${DOCKER_NETWORK:-br}` if needed

### Unexposed WebUI
In most cases, run applications behind a reverse proxy is recommended, so ports for WebUI is not exposed in the base `docker-compose.yml` file by default.

You can set up a reverse proxy using docker and connect it to [the `br` network](#user-defined-network), then it's possible to use the container name as the hostname to connect to the application.

Alternatively, you can use `docker-compose.port.webui.yml` file as described in [Extra compose files](#extra-compose-files) to expose WebUI ports. The default ports are the same as inside container, you can change them using environment variables `PORT_WEBUI_HTTP` and `PORT_WEBUI_HTTPS` (if the app provides https connection).

### Extra compose files
Each branch has a `docker-compose.yml` as base file, but some applications may need extra files to work as you wish. For example, to add hardware-accelerated video decoding to Jellyfin, a series of `docker-compose.ha.<method>.yml` are provided.

To use them, you can use multiple `-f` flags to specify extra files. Please refer to [official documentation](https://docs.docker.com/compose/reference/overview/#specifying-multiple-compose-files) for more information.

### Use of mirror
You can use `DOCKER_MIRROR=<url> docker compose up` to pull from a mirror instead of the default docker.io or lscr.io, etc.

Set from `.env` file is also supported.

### Application-specific notes
In some cases, there will be application-specific notes below.

---
# Nginx-Proxy-Manager-specific notes
## Using internal container service names as proxy hosts
As mentioned in [this issue](NginxProxyManager/nginx-proxy-manager/issues/2423), internal container service names may be resolved by a public ipv6 DNS server, which may cause 502 error while trying to access the proxied services. Logs are as follows:

```bash
[root@nginx-proxy-manager:/]# cat /data/logs/proxy-host-1_error.log
YYYY/MM/DD hh:mm:ss [error] 216#216: *60 <service name> could not be resolved (3: Host not found), client: <client address>, server: <hostname>, request: "GET / HTTP/2.0", host: "<hostname>"
```

A quick solution is just to disable those ipv6 DNS servers in `/etc/nginx/conf.d/include/resolvers.conf`. However, in nginx-proxy-manager, this file is generated from `/etc/resolv.conf`, see [this file](https://github.com/NginxProxyManager/nginx-proxy-manager/blob/master/docker/rootfs/etc/s6-overlay/s6-rc.d/prepare/40-dynamic.sh), so the solution is to modify `/etc/resolv.conf` in the container.

We can do this by mounting a modified `resolv.conf` to the container. (i.e. `volumes: [ ./resolv.conf:/etc/resolv.conf:ro ]` in `docker-compose.resolvers.yml`)

`docker-compose.resolvers.yml` will do the trick for you, use it as described in [extra compose files](#extra-compose-files).
