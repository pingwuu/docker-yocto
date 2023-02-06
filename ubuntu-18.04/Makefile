all: build

build:
	docker build -t pingwuu/yocto-build:ubuntu-18.04 .
rebuild:
	docker build --no-cache -t pingwuu/yocto-build:ubuntu-18.04 .

run:
	docker run -it pingwuu/yocto-build:ubuntu-18.04

deploy:
	docker push pingwuu/yocto-build:ubuntu-18.04
