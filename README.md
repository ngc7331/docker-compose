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
# Nextcloud-specific notes
## Installation
Although env variables (e.g. `MYSQL_HOST`) is set in compose file, reading db configuration from env variables is NOT supported by linuxserver/nextcloud image now.

Therefore, it is necessary to use the web-based installer to finish the installation. Select MySQL/MariaDB as  fill in the db configuration as follows:

```
Database user: nextcloud
Database password: <as set in env for nextcloud-db>
Database name: nextcloud
Database host: nextcloud-db
```

Luckily, linuxserver/mariadb image supports reading db configuration from env variables, so there's no need to pay extra attention to db configuration.

## Mount host filesystem into container
You can use `docker-compose.mnt.host.yml` to mount host filesystem `/` into container `/host/`. This is useful when you want to access host files from within the container (e.g. [Nextcloud external storage](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage/local.html)).

The default mount options are `ro` (read-only), you can change it to `rw` (read-write) by setting `MOUNT_HOST_MODE=rw`.

**But also, this could be dangerous, please be careful.**
