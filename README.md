# Supported tags and respective `Dockerfile` links

-	[`latest`, `1.8`, `1.8.21` (*Dockerfile*)](https://github.com/mybb/docker/blob/master/Dockerfile)

# Quick reference

-	**Where to get help**:  
	[the MyBB Community Forums](https://community.mybb.com/)

-	**Where to file issues**:  
	[https://github.com/mybb/docker/issues](https://github.com/mybb/docker/issues)

-	**Maintained by**:  
	[the MyBB Team](https://mybb.com/about/team/)

# What is MyBB?

MyBB is the free and open source, intuitive, extensible, and incredibly powerful forum software you've been looking for. With everything from forums to threads, posts to private messages, search to profiles, and reputation to warnings, MyBB features everything you need to run an efficient and captivating community. Through plugins and themes, you can extend MyBB's functionality to build your community exactly as you'd like it. Learn more at [MyBB.com](https://mybb.com).

> [wikipedia.org/wiki/MyBB](https://en.wikipedia.org/wiki/MyBB)

![logo](https://mybb.com/assets/images/logo.png)

# How to use this image

```console
$ docker container run mybb/mybb:latest
```

This image only provides a MyBB service container running PHP7.X-FPM. There are no database, cache or nginx container(s) provided, you'll need to use Docker Compose or Stack to wrange those additional services to your MyBB instance. Please see the provided mysqli/pgsql Compose example files in the official repository, [here](https://github.com/mybb/docker-compose). A very basic example has also been provided below.

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `mybb`:

```yaml
services:
  mybb:
    image: mybb/mybb:latest
    volumes:
    - ${PWD}/mybb:/var/www/html:rw
  nginx:
    image: nginx:mainline
    ports:
    - published: 8080
      target: 80
    volumes:
    - ${PWD}/mybb:/var/www/html:ro
  postgresql:
    environment:
      POSTGRES_DB: mybb
      POSTGRES_PASSWORD: changeme
      POSTGRES_USER: mybb
    image: postgres:11.3
    volumes:
    - ${PWD}/postgres/data:/var/lib/postgresql/data:rw
version: '3.6'
```

# How to build this image

You must provide four build-time arguments when building this Docker image, `BUILD_AUTHORS`, `BUILD_DATE`, `BUILD_SHA1SUM` and `BUILD_VERSION`.
```
docker build \                  
  --build-arg BUILD_AUTHORS="Kane 'kawaii' Valentine <kawaii@mybb.com>" \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg BUILD_SHA1SUM=b415ef89f932690cbfad9fbdb51932071d356555 \
  --build-arg BUILD_VERSION=1821pl1 \
  --tag mybb/mybb:1.8 \
  --tag mybb/mybb:1.8.21 \
  --tag mybb/mybb:latest \
  $PWD
```
The resulting image can then be pushed to the [`mybb/mybb`](https://cloud.docker.com/u/mybb/repository/docker/mybb/mybb) Docker Hub repository:
```
docker push mybb/mybb:1.8.21
```
