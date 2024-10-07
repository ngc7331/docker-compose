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
# QBittorrent-specific notes
## Ports for incoming connections
QBittorrent uses port 6881 for incoming connections by default. However, this port is blacklisted by some of trackers and ISPs.

Also, peers uses client's reported port to connect to it, so port forwarding by docker like `16881:6881/tcp` is not useable.

Therefore, the port is set to be changeable by environment variable `PORT_BITTORRENT` and default to 6881. You can change it to any port you like.

Do not forget to change the port in QBittorrent's settings as well.

## Extra mountpoints
Sometimes it is useful to mount some extra directories to QBittorrent container, for example, to download torrents directly to media library managed by Jellyfin.

To implement this, `docker-compose.mnt.<extra>.yml` is provided. You can use them as described in [extra compose files](#extra-compose-files).

## qBittorrent-ClientBlocker
[Official repo](https://github.com/Simple-Tracker/qBittorrent-ClientBlocker)

Ban XunLei, etc. clients from connecting to your qbittorrent.

In order for the blocker to connect to your qbittorent API, you need to check `Options > Web UI > Web User Interface (Remote control) > Authentication > Bypass Authentication of Clients on Whitelisted IP Subnets` and fill in subnet(CIDR) of your docker network in qbittorent WebUI.
