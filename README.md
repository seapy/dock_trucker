# Dock Trucker

![Dock Trucker](images/dock-trucker-logo.png "Dock Trucker")

Docker Volume container auto backup and sync to cloud

`Dock Trucker` container only one run and forgot it.

* run with `--volumes-from` and that volume container will be backup
* default only backup your host
* old file delete
* sync to s3
* backup every day

[![Youtube](http://img.youtube.com/vi/peqidRTwTEs/0.jpg)](http://youtu.be/peqidRTwTEs)

[slide](http://slides.com/seapy/dock-trucker)


# Run

```
$ docker run -d --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /your/host/backup/dir:/backup \
    --volumes-from backup1 \
    --volumes-from backup2 \
    -e AWS_ACCESS_KEY_ID=yourkeyid \
    -e AWS_SECRET_ACCESS_KEY=youraccesskey \
    -e AWS_DEFAULT_REGION=us-east-1 \
    -e S3_PATH=s3_bucketname_or_path \
    -e OLDFILE_PRESERVE_DAYS=14 \
    seapy/dock-trucker
```

add `--volumes-from` for backup volume container

## CONS

* if your volumes is `/backup` it's not works...
* AWS S3 Region works only `us-east-1`. `aws-cli` problem


## Backup Dir

if your volume container 

```
# `backup1` volume container volumes
/app/upload
/db/data

# `backup2` volume container volumes
/redis/data
/static/web/js
```

result backup tree like this

```
/backup
  backup1
    app_upload-20141101-0940.tar
    db_data-20141101-0940.tar
  backup2
    redis_data-20141101-0940.tar
    static_web_js-20141101-0940.tar
```


# for ME(or contributors)

## Build

```
$ docker build -t seapy/dock-trucker .
```

## in Development

for only source code change

change `/Users/seapy` to your directory

```
$ docker run -it --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /Users/seapy/backup:/backup \
    -v /Users/seapy/Documents/Docker/volume_backup:/app \
    --volumes-from backup1 \
    seapy/dock-trucker \
    /bin/bash

$ bundle exec ruby entry.rb
```
