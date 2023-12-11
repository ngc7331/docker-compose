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

### Use of mirror
You can use `DOCKER_MIRROR=<url> docker compose up` to pull from a mirror instead of the default docker.io or lscr.io, etc.

Set from `.env` file is also supported.
