# Docker compose
Repo for my docker-compose files

Each application's files are on a separate branch

## Notes
### User-defined network
Applications may use a external network "br" as follows:

```
networks:
  br:
    external: true
    name: br
```

create it manually by `docker network create br` if needed

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
# Portainer-specific notes
## Edition
By default, Portainer Business Edition is used. You can go [here](https://www.portainer.io/take-3) to get a 3-nodes free license.

To use Portainer Community Edition, use `docker-compose.ce.yml` as described in [Extra compose files](#extra-compose-files).

## Edge clients
If you plan to use the Edge compute features with Edge agents, note that those agents will connect to server using `8000/tcp` port.

To expose this extra port, use `docker-compose.port.edge.yml` as described in [Extra compose files](#extra-compose-files).
