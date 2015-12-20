# Dock Trucker

![Dock Trucker](images/dock-trucker-logo.png "Dock Trucker")

Docker Volume container auto backup and sync to cloud

`Dock Trucker` container only one run and forgot it.

* run with `--volumes-from` and that volume container will be backup
* default only backup your host
* old file delete
* sync to s3, rsync
* backup every day

[![Youtube](http://img.youtube.com/vi/peqidRTwTEs/0.jpg)](http://youtu.be/peqidRTwTEs)

[slide](http://slides.com/seapy/dock-trucker)


# Run

```
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /your/host/backup/dir:/backup \
    --volumes-from backup1 \
    --volumes-from backup2 \
    -e AWS_ACCESS_KEY_ID=yourkeyid \
    -e AWS_SECRET_ACCESS_KEY=youraccesskey \
    -e AWS_DEFAULT_REGION=us-east-1 \
    -e STORE_NAME=store name \
    -e STORE_PATH=s3_bucketname_or_path \
    -e OLDFILE_PRESERVE_DAYS=14 \
    seapy/dock-trucker
```

add `--volumes-from` for backup volume container

## Exmaple 

### S3 Store

```
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/ubuntu/backup:/backup \
    --volumes-from pg-data \
    --volumes-from rails-uploads \
    -e OLDFILE_PRESERVE_DAYS=14 \
    -e STORE_NAME=s3 \
    -e S3_PATH=seapy-bucket/rails \
    -e AWS_ACCESS_KEY_ID=xxxx \
    -e AWS_SECRET_ACCESS_KEY=yyyy \
    -e AWS_DEFAULT_REGION=us-east-1 \
    seapy/dock-trucker
```

### Rsync Store

```
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/ubuntu/backup:/backup \
    --volumes-from pg-data \
    --volumes-from rails-uploads \
    -e OLDFILE_PRESERVE_DAYS=14 \
    -e STORE_NAME=rsync \
    -e RSYNC_OPTIONS="-azrL --delete" \
    -e RSYNC_DEST_PATH="example.com:/backup/path" \
    seapy/dock-trucker
```

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
$ docker run --name dock_trucker-test-backup1 \
    -v /data \
    busybox

$ docker run --name dock_trucker-test-backup2 \
    -v /data2 \
    busybox
```

```
$ docker run -it --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /Users/seapy/backup:/backup \
    -v /Users/seapy/Documents/docker/dock_trucker:/app \
    --volumes-from dock_trucker-test-backup1 \
    --volumes-from dock_trucker-test-backup2 \
    seapy/ruby:2.2.0 \
    /bin/bash
$ apt-get install -y awscli
$ export AWS_ACCESS_KEY_ID="xxxx" \
export AWS_SECRET_ACCESS_KEY="yyyy" \
export AWS_DEFAULT_REGION=us-east-1 \
export STORE_PATH=seapy-tmp/dock_trucker_test
$ cd /app
$ bundle install
$ ./run.sh s3
```

