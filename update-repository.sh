#/bin/bash
apt update -y
cp id.ubuntu.sources /etc/apt/sources.list.d/
mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/.ubuntu.sources.backup
mv /etc/apt/sources.list.d/id.ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources
apt update -y
