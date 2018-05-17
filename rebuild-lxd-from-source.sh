#!/bin/sh

## Подготовка необходимой для сборки LXD версии интерпретатора GO
add-apt-repository -y ppa:longsleep/golang-backports
apt-get update
apt-get install -y golang-1.8
apt-get install -y golang-1.6
rm /usr/bin/go
update-alternatives --quiet --remove-all go
update-alternatives --quiet --install /usr/bin/go go  /usr/lib/go-1.6/bin/go 0
update-alternatives --quiet --install /usr/bin/go go  /usr/lib/go-1.8/bin/go 10
update-alternatives --set go  /usr/lib/go-1.8/bin/go

## Устанавливаем необходимые для сборки LXC/LXD и CRIU пакеты
apt-get install -y acl dnsmasq-base git golang libacl1-dev make pkg-config rsync 
apt-get install -y squashfs-tools tar xz-utils lvm2 thin-provisioning-tools btrfs-tools curl gettext
apt-get install -y jq sqlite3 uuid-runtime bzr m4 automake autoconf
apt-get install -y protobuf-c-compiler libnet1-dev libaio-dev asciidoc libcap-dev 
apt-get install -y libnl-3-dev python-protobuf golang-gogoprotobuf-dev libprotobuf-dev apparmor-utils
apt-get install -y libcgmanager-dev libseccomp-dev docbook libtool

## Удаляем все потенциально установленные в системе пакеты (LXC/LXD/CRIU)
apt-get purge -y liblxc0 liblxc1 lxc lxcfs lxctl
apt-get purge -y lxd lxd-client lxd-tools

## Производим сборку LXC/LXD и CRIU из исходных кодов
## == Build LXC
cd /usr/src
rm -rf ./lxc/
git clone https://github.com/lxc/lxc.git
cd ./lxc/
./autogen.sh
./configure
make && make install
grep -qF -- "/usr/local/lib" /etc/ld.so.conf || echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

##== Build CRIU
cd /usr/src/
rm -rf ./criu/ 
git clone https://github.com/checkpoint-restore/criu.git
cd ./criu/
make && make install

#== Build LXD
cd /usr/src
mkdir /usr/src/go
export GOPATH=/usr/src/go
cd $GOPATH
rm -rf ./lxd/
git clone --recursive https://github.com/lxc/lxd.git
cd ./lxd
make
cd $GOPATH/src/github.com/lxc/lxd
make
cp -rf /usr/src/go/bin/* /usr/local/bin/

#== Clean Space
apt-get clean
rm -rf /usr/src/criu/
rm -rf /usr/src/go/
rm -rf /usr/src/lxc/
