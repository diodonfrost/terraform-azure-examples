#!/bin/bash

echo "hello world"
echo "test" > /tmp/test.txt

apt-get update && apt-get install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb
