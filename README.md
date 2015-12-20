# Dock Trucker

![Dock Trucker](images/dock-trucker-logo.png "Dock Trucker")

Docker Volume container auto backup and sync to cloud

`Dock Trucker` container only one run and forgot it.

* run with `--volumes-from` and that volume container will be backup
* default only backup your host
* old file delete
* sync to s3, rsync, dropbox
* backup every day

[![Youtube](http://img.youtube.com/vi/peqidRTwTEs/0.jpg)](http://youtu.be/peqidRTwTEs)

[slide](http://slides.com/seapy/dock-trucker)


# Run

add `--volumes-from` for backup volume container

### S3 Store

```
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/ubuntu/backup:/backup \
    --volumes-from pg-data \
    --volumes-from rails-uploads \
    -e OLDFILE_PRESERVE_DAYS=14 \
    -e STORE_NAME=s3 \
    -e S3_PATH=seapy-bucket/backup \
    -e AWS_ACCESS_KEY_ID=xxxx \
    -e AWS_SECRET_ACCESS_KEY=yyyy \
    -e AWS_DEFAULT_REGION=us-east-1 \
    seapy/dock-trucker:1.0.0
```

* STORE_NAME
    * `s3`
* S3_PATH
    * bucket and path
    * `bucket_name/path`
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION
    * `us-east-1`, another regions is not works

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
    -e RSYNC_DEST_PATH="example.com:/mybackup/path" \
    seapy/dock-trucker:1.0.0
```

* STORE_NAME
    * `rsync`
* RSYNC_OPTIONS
    * rsync command options like `-avz`, `-aL` or `-azrL --delete`. default value is `-azrL --delete`
* RSYNC_DEST_PATH
    * rsync destination path like `example.com:/mybackup/path`

### Dropbox Store

```
$ docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/ubuntu/backup:/backup \
    --volumes-from pg-data \
    --volumes-from rails-uploads \
    -e OLDFILE_PRESERVE_DAYS=14 \
    -e STORE_NAME=dropbox \
    -e DROPBOX_PATH="mybackup/path" \
    -v /home/ubuntu/.dropbox_uploader:/root/.dropbox_uploader \
    seapy/dock-trucker:1.0.0
```

* STORE_NAME
    * `dropbox`
* DROPBOX_PATH
    * your dropbox path to backup
* `/root/.dropbox_uploader`
    * need for dropbox link. see [more information](https://github.com/andreafabrizi/Dropbox-Uploader)

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
$ docker build -t seapy/dock-trucker:1.0.0 .
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
$ cd /app
$ bundle install
```

