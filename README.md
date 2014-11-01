# Volume Backup

Docker Volume container auto backup and send to cloud

* run with `--volumes-from` and that volume container will be backup
* default only backup your host
* TODO : old file delete. file exists days read from args or ENV?... or volume cotainers ENV(wow!)
* TODO : sync to s3(aws cmd or aws ruby sdk). API_KEY, S3 PATH from ENV
* TODO : run with cron. `volume backup` container only one run and forgot it.


# Run

```
$ docker run -it --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /your/host/backup/dir:/backup \
    --volumes-from backup1 \
    --volumes-from backup2 \
    -e AWS_ACCESS_KEY_ID=yourkeyid \
    -e AWS_SECRET_ACCESS_KEY=youraccesskey \
    -e AWS_DEFAULT_REGION=us-east-1 \
    -e S3_PATH=s3_bucketname_or_path \
    -e OLDFILE_PRESERVE_DAYS=14 \
    seapy/volume-backup
```

add `--volumes-from` for backup volume container

if your volumes is `/backup` it's not works...


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
$ docker build -t seapy/volume-backup .
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
    seapy/volume-backup \
    /bin/bash

$ bundle exec ruby entry.rb
```