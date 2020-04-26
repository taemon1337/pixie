SHELL=/bin/bash
PWD=`pwd`
IMAGE=pixiecore/pixiecore:master
VMLINUX=coreos_production_pxe.vmlinuz
CPIO=coreos_production_pxe_image.cpio.gz
IMAGEDIR=/image
NAME=pixie
CMDLINE='coreos.autologin cloud-config-url={{ ID "./my-cloud-config.yml" }}'
.PHONY: run vmlinux cpio pull

up:
	docker run --privileged --name ${NAME} -d --net=host -v ${PWD}:${IMAGEDIR} ${IMAGE} boot --debug --status-port 80 --listen-addr 0.0.0.0 ${IMAGEDIR}/${VMLINUX} ${IMAGEDIR}/${CPIO} --cmdline=${CMDLINE}

down:
	docker rm -vf ${NAME}

logs:
	docker logs -f ${NAME}

pull:
	docker pull ${IMAGE}

vmlinux:
	wget https://alpha.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz

cpio:
	wget https://alpha.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz

