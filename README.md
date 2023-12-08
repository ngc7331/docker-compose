# Docker compose
Repo for my docker-compose files

Each application's files are on a separate branch

## NOTES
### User-defined network
Applications may use a external network "br" as follows:

```
networks:
  br:
    external: true
    name: br
```

create it manually by `docker network create br` if needed
