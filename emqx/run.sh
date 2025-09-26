#!/bin/bash

current_dir=$(pwd)
current_dir_name=$(basename "$current_dir")
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#chown -R $(id -u):$(id -g) "$script_dir/etc" "$script_dir/log"
#chown -R root:root "$script_dir/etc" "$script_dir/log"
chown -R 1000:1000 "$script_dir/log"

docker run -d --name emqx \
    -p 34649:1883 -p 30873:8083 -p 33805:18083 \
    -e TimeZone=Asia/Shanghai \
    -v /etc/localtime:/etc/localtime \
    -v $script_dir/etc/acl.conf:/opt/emqx/etc/acl.conf \
    -v $script_dir/etc/base.hocon:/opt/emqx/etc/base.hocon \
    -v $script_dir/etc/emqx.conf:/opt/emqx/etc/emqx.conf \
    -v $script_dir/log:/opt/emqx/log \
    --restart unless-stopped \
    emqx/emqx:5.8.6

