#!/bin/bash

echo "hello world"
echo "test" > /tmp/test.txt

apt-get update && apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
