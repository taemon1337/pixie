SHELL=/bin/sh
PWD=`pwd`
IMAGE=pixiecore/pixiecore:master
COREOS_VMLINUX=coreos_production_pxe.vmlinuz
COREOS_ROOTFS=coreos_production_pxe_image.cpio.gz
RANCHER_VMLINUX=rancheros.vmlinux
RANCHER_ROOTFS=rancheros-rootfs.tar.gz
IMAGEDIR=/image
GOLANG=golang:alpine
NAME=pixie
CMDLINE='coreos.autologin cloud-config-url={{ ID "./my-cloud-config.yml" }}'
.PHONY: run vmlinux cpio pull build gobuild

coreos:
	docker run --privileged --name ${NAME} -d --net=host -v ${PWD}:${IMAGEDIR} ${IMAGE} boot --debug --status-port 80 --listen-addr 0.0.0.0 ${IMAGEDIR}/${COREOS_VMLINUX} ${IMAGEDIR}/${COREOS_ROOTFS} --cmdline=${CMDLINE}

rancher:
	docker run --privileged --name ${NAME} -d --net=host -v ${PWD}:${IMAGEDIR} ${IMAGE} boot --debug --status-port 80 --listen-addr 0.0.0.0 ${IMAGEDIR}/${RANCHER_VMLINUX} ${IMAGEDIR}/${RANCHER_ROOTFS} --cmdline=${CMDLINE}

down:
	docker rm -vf ${NAME}

logs:
	docker logs -f ${NAME}

pull:
	docker pull ${IMAGE}

coreos-vmlinux:
	wget https://alpha.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz

coreos-rootfs:
	wget https://alpha.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz

rancheros-vmlinux:
	wget https://github.com/rancher/os/releases/download/v1.5.5/vmlinuz -O ${RANCHER_VMLINUX}

rancheros-rootfs:
	wget https://github.com/rancher/os/releases/download/v1.5.5/rootfs.tar.gz -O ${RANCHER_ROOTFS}

build:
	docker run -it -v ${PWD}/build:/go/build -v ${PWD}/bin:/go/bin:rw -v ${PWD}/src:/go/src ${GOLANG} sh /go/build


